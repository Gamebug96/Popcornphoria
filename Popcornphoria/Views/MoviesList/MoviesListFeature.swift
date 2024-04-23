//
//  HomeReducer.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 24/03/24.
//

import ComposableArchitecture
import Dependencies
import SwiftUI

@Reducer
struct MoviesListFeature {
   @Reducer(state: .equatable)
   enum Path {
      case genreMovies(GenreMoviesListingFeature)
      case movieDetail(MovieDetailFeature)
      case reviews(ReviewsFeature)
   }

   @ObservableState
   struct State: Equatable {
      var isLoading = false
      var genres = [Genre]()
      var selectedMenu = MoviesMenu.nowPlaying
      var movies = [Movie]()
      var path = StackState<Path.State>()
   }

   enum Action {
      case didReceiveError(_ error: String)
      case fetchGenres
      case fetchMovies
      case genreResponse(GenreResponse)
      case menuSelected(_ menu: MoviesMenu)
      case moviesListResponse(PaginatedResponse<Movie>)
      case path(StackAction<Path.State, Path.Action>)
   }

   @Dependency(\.movieClient) var movieClient

   var body: some ReducerOf<Self> {
      Reduce { state, action in
         switch action {
         case .didReceiveError(let error):
            print("Error received: \(error)")
            return .none
         case .fetchGenres:
            state.isLoading = true
            return .run { send in
               do {
                  let result = try await movieClient.fetchGenres()
                  await send(.genreResponse(result))
               } catch let error {
                  await send(.didReceiveError(error.localizedDescription))
               }
            }
         case .fetchMovies:
            state.movies = []
            return .run { [menu = state.selectedMenu] send in
               do {
                  let result = try await movieClient.fetchMovies(menu.endpoint)
                  await send(.moviesListResponse(result))
               } catch let error {
                  await send(.didReceiveError(error.localizedDescription))
               }
            }
         case .genreResponse(let response):
            state.genres = response.genres
            return .send(.fetchMovies)
         case .menuSelected(let menu):
            state.selectedMenu = menu
            return .send(.fetchMovies)
         case .moviesListResponse(let response):
            state.movies.append(contentsOf: response.results)
            state.isLoading = false
            for (index, movie) in state.movies.enumerated() {
               guard let genreIds = movie.genreIds else {
                  continue
               }

               for id in genreIds {
                  guard let genre = state.genres.first(where: { $0.id == id }) else {
                     continue
                  }
                  if state.movies[index].genres == nil {
                     state.movies[index].genres = [genre]
                  } else {
                     state.movies[index].genres?.append(genre)
                  }
               }
            }
            return .none
         case .path(_):
            return .none
         }
      }.forEach(\.path, action: \.path)
   }
}
