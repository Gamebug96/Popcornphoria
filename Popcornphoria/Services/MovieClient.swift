//
//  MovieClient.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 24/03/24.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct MovieClient {
   var fetchCasts: @Sendable (_ movieID: Int) async throws -> CreditsResponse
   var fetchGenres: @Sendable () async throws -> GenreResponse
   var fetchMovies: @Sendable (_ menu: String) async throws -> PaginatedResponse<Movie>
   var fetchRecommendedMovies: @Sendable (_ movieID: Int) async throws -> PaginatedResponse<Movie>
   var fetchReviews: @Sendable (_ movieID: Int) async throws -> PaginatedResponse<Review>
   var fetchSimilarMovies: @Sendable (_ movieID: Int) async throws -> PaginatedResponse<Movie>
}

extension MovieClient: DependencyKey {
   static var liveValue = live()

   static func live() -> Self {
      @Dependency(\.apiClient) var apiClient

      return .init { movieID in
         try await apiClient.apiRequest(.credits(for: movieID) as Endpoint<CreditsResponse>)
      } fetchGenres: {
         try await apiClient.apiRequest(.genreList() as Endpoint<GenreResponse>)
      } fetchMovies: { menu in
         try await apiClient.apiRequest(.moviesList(for: menu) as Endpoint<PaginatedResponse<Movie>>)
      } fetchRecommendedMovies: { movieID in
         try await apiClient.apiRequest(.recommendedMovies(for: movieID) as Endpoint<PaginatedResponse<Movie>>)
      } fetchReviews: { movieID in
         try await apiClient.apiRequest(.reviews(for: movieID) as Endpoint<PaginatedResponse<Review>>)
      } fetchSimilarMovies: { movieID in
         try await apiClient.apiRequest(.similarMovies(for: movieID) as Endpoint<PaginatedResponse<Movie>>)
      }
   }
}

extension MovieClient: TestDependencyKey {
   static let previewValue = Self(
      fetchCasts: { movieID in
         .init(id: 0, cast: [], crew: [])
      },
      fetchGenres: {
         .init(genres: [])
      },
      fetchMovies: { menu in
         .init(page: 1, total_results: 1, total_pages: 1, results: [.stub])
      },
      fetchRecommendedMovies: { movieID in
         .init(page: 1, total_results: 1, total_pages: 1, results: [.stub])
      },
      fetchReviews: { movieID in
         .init(page: 1, total_results: 1, total_pages: 1, results: [.stub])
      },
      fetchSimilarMovies: { movieID in
         .init(page: 1, total_results: 1, total_pages: 1, results: [.stub])
      }
   )

   static let testValue = Self()
}

extension DependencyValues {
   var movieClient: MovieClient {
      get { self[MovieClient.self] }
      set { self[MovieClient.self] = newValue }
   }
}
