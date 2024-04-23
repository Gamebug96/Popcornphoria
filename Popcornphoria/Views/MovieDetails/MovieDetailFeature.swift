//
//  MovieDetailFeature.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 06/04/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MovieDetailFeature {
   @ObservableState
   struct State: Equatable {
      var movie: Movie
      var casts = [People]()
      var director: People?
      var isOverviewExpanded = false
      var recommendedMovies = [Movie]()
      var reviews = [Review]()
      var similarMovies = [Movie]()
   }

   enum Action: Equatable {
      case addToFavorite(_ isLocalChange: Bool)
      case addToWatchlist(_ isLocalChange: Bool)
      case creditsFetched(CreditsResponse)
      case didReceiveError(_ error: String)
      case expandOverview
      case recommendedMoviesFetched(PaginatedResponse<Movie>)
      case reviewsFetched(PaginatedResponse<Review>)
      case similarMoviesFetched(PaginatedResponse<Movie>)
      case task
      case userAction(UserAction)

      enum UserAction: Equatable {
         case favorite(Bool)
         case watchlist(Bool)
      }
   }

   @Dependency(\.movieClient) var movieClient
   @Dependency(\.userClient) var userClient

   var body: some ReducerOf<Self> {
      Reduce {
         state,
         action in
         switch action {
         case .addToFavorite(let isLocalChange):
            if isLocalChange {
               state.movie.isFavorite = true
               return .none
            }
            return .run { [movieID = state.movie.id] send in
               do {
                  let response = try await userClient.addToFavorite(
                     request: .init(mediaId: movieID, favorite: true)
                  )
               } catch {
                  await send(.didReceiveError(error.localizedDescription))
               }
            }
         case .addToWatchlist(let isLocalChange):
            if isLocalChange {
               state.movie.isInWatchlist = true
               return .none
            }
            return .none
         case .creditsFetched(let response):
            state.casts = response.cast.uniqued()
            state.director = response.crew.filter({ $0.department == "Directing" }).first
            return .none
         case .didReceiveError(let error):
            return .none
         case .expandOverview:
            state.isOverviewExpanded.toggle()
            return .none
         case .recommendedMoviesFetched(let data):
            state.recommendedMovies = data.results
            return .none
         case .reviewsFetched(let response):
            state.reviews = response.results
            return .none
         case .similarMoviesFetched(let data):
            state.similarMovies = data.results
            return .none
         case .task:
            return .run { [movieID = state.movie.id] send in
               if let favoritesMovies = await userClient.favoriteMovies(),
                  favoritesMovies.contains(where: { $0.id == movieID }) {
                  await send(.addToFavorite(true))
               }
               
               if let watchlist = await userClient.watchlist(),
                  watchlist.contains(where: { $0.id == movieID }) {
                  await send(.addToWatchlist(true))
               }
               
               do {
                  async let credits = movieClient.fetchCasts(movieID: movieID)
                  async let recommendedMovies = movieClient.fetchRecommendedMovies(movieID: movieID)
                  async let reviews = movieClient.fetchReviews(movieID: movieID)
                  async let similarMovies = movieClient.fetchSimilarMovies(movieID: movieID)
                  let result = try await (credits, recommendedMovies, reviews, similarMovies)
                  await send(.creditsFetched(result.0))
                  await send(.recommendedMoviesFetched(result.1))
                  await send(.reviewsFetched(result.2))
                  await send(.similarMoviesFetched(result.3))
               } catch {
                  await send(.didReceiveError(error.localizedDescription))
               }
            }
         case .userAction(let action):
            switch action {
            case .favorite(let isFavorite):
               break
            case .watchlist(let isInWatchlist):
               break
            }
            return .none
         }
      }
   }
}
