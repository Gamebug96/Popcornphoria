//
//  GenreFeature.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 16/04/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct GenreMoviesListingFeature {
   @ObservableState
   struct State: Equatable {
      let genre: Genre
      var movies = PaginatedResponse<Movie>(page: 1, total_results: nil, total_pages: nil, results: [])
   }

   enum Action {
      case didAppear
      case didFetchMovies(_ movies: PaginatedResponse<Movie>)
   }

   @Dependency(\.genreClient) var genreClient

   var body: some ReducerOf<Self> {
      Reduce { state, action in
         switch action {
         case .didAppear:
            return .run { [genreID = state.genre.id] send in
               let data = try await genreClient.fetchMovies(.init(withGenres: "\(genreID)"))
               await send(.didFetchMovies(data))
            }
         case .didFetchMovies(let movies):
            state.movies = movies
            return .none
         }
      }
   }
}
