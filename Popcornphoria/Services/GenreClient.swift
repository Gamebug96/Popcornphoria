//
//  GenreClient.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 16/04/24.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct GenreClient {
   var fetchGenres: @Sendable () async throws -> GenreResponse
   var fetchMovies: @Sendable(GenreMoviesRequest) async throws -> PaginatedResponse<Movie>
}

extension GenreClient: DependencyKey {
   static var liveValue = live()

   static func live() -> Self {
      @Dependency(\.apiClient) var apiClient

      return .init {
         try await apiClient.apiRequest(.genreList() as Endpoint<GenreResponse>)
      } fetchMovies: { request in
         try await apiClient.apiRequest(.discover(queryParams: request) as Endpoint<PaginatedResponse<Movie>>)
      }
   }
}

extension DependencyValues {
   var genreClient: GenreClient {
      get { self[GenreClient.self] }
      set { self[GenreClient.self] = newValue }
   }
}
