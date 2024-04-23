//
//  AppFeature.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 21/04/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AppFeature {
   enum Tab {
      case moviesList
      case profile
   }

   @Reducer(state: .equatable)
   enum Path {
      case genreMovies(GenreMoviesListingFeature)
      case movieDetail(MovieDetailFeature)
      case reviews(ReviewsFeature)
   }

   @ObservableState
   struct State: Equatable {
      var appState = AuthorizationState.notAuthorized
      var currentTab = Tab.moviesList
      var genres = GenresFeature.State()
      var moviesList = MoviesListFeature.State()
      var path = StackState<Path.State>()
      var userProfile = ProfileFeature.State()
      var requestToken: String?

      enum AuthorizationState: Equatable {
         case authorized
         case error(_ error: String)
         case isLoading
         case notAuthorized
         case webAuthorization(_ url: URL?)
      }
   }

   enum Action {
      case authorizationCompleted
      case didReceiveError(_ error: String)
      case genres(GenresFeature.Action)
      case moviesList(MoviesListFeature.Action)
      case path(StackAction<Path.State, Path.Action>)
      case userProfile(ProfileFeature.Action)
      case profileDataFetched(_ favorites: [Movie], _ watchlist: [Movie])
      case selectTab(Tab)
      case tokenFetched(_ token: String)
      case tokenVerified
      case task
   }

   @Dependency(\.userClient) var userClient
   @Dependency(\.userDefaults) var userDefaults

   var body: some ReducerOf<Self> {
      Scope(state: \.moviesList, action: \.moviesList) {
         MoviesListFeature()
      }

      Scope(state: \.genres, action: \.genres) {
         GenresFeature()
      }

      Scope(state: \.userProfile, action: \.userProfile) {
         ProfileFeature()
      }

      Reduce { state, action in
         switch action {
         case .authorizationCompleted:
            state.appState = .authorized
            return .none
         case .didReceiveError(let error):
            state.appState = .error(error)
            return .none
         case .genres:
            return .none
         case .moviesList:
            return .none
         case .path:
            return .none
         case .userProfile:
            return .none
         case .profileDataFetched:
            return .none
         case let .selectTab(tab):
            state.currentTab = tab
            return .none
         case .tokenFetched(let token):
            let url = URL(string: "\(Constants.tokenValidationURL + token)")
            state.requestToken = token
            state.appState = .webAuthorization(url)
            return .none
         case .tokenVerified:
            guard let token = state.requestToken else {
               return .none
            }
            return .run { send in
               do {
                  let session = try await userClient.fetchSessionID(request: .init(requestToken: token))
                  await userDefaults.setSessionID(session.sessionId)
                  _ = try? await userClient.refreshProfileData()
                  await send(.authorizationCompleted)
               } catch {
                  await send(.didReceiveError(error.localizedDescription))
               }
            }
         case .task:
            state.appState = .isLoading
            return .run { send in
               if let _ = userDefaults.sessionID {
                  _ = try? await userClient.refreshProfileData()
                  await send(.authorizationCompleted)
               } else {
                  do {
                     let token = try await userClient.fetchRequestToken()
                     await send(.tokenFetched(token.requestToken))
                  } catch {
                     await send(.didReceiveError(error.localizedDescription))
                  }
               }
            }
         }
      }.forEach(\.path, action: \.path)
   }
}
