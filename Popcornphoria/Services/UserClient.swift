//
//  UserClient.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 20/04/24.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct UserClient {
   var addToFavorite: @Sendable (_ request: FavoriteRequest) async throws -> ResponseModel
   var addToWatchlist: @Sendable (_ request: WatchlistRequest) async throws -> ResponseModel
   var favoriteMovies: @Sendable () async -> [Movie]?
   var fetchRequestToken: @Sendable () async throws -> SessionToken
   var fetchSessionID: @Sendable (_ request: SessionToken) async throws -> UserSession
   var refreshProfileData: @Sendable () async throws -> (PaginatedResponse<Movie>, PaginatedResponse<Movie>)
   var watchlist: @Sendable () async -> [Movie]?

   struct SessionToken: Codable {
      let requestToken: String
   }

   struct FavoriteRequest: Encodable {
      let mediaType = "movie"
      let mediaId: Int
      let favorite: Bool
   }

   struct WatchlistRequest: Encodable {
      let mediaType = "movie"
      let mediaId: Int
      let watchlist: Bool
   }
}

extension UserClient: DependencyKey {
   static var liveValue = live()

   static func live() -> Self {
      @Dependency(\.apiClient) var apiClient
      @Dependency(\.userDefaults) var userDefaults

      actor Session {
         nonisolated let apiClient: APIClient
         nonisolated let userDefaults: UserDefaultsClient
         var favorites = [Movie]()
         var watchlist = [Movie]()

         init(
            apiClient: APIClient,
            userDefaults: UserDefaultsClient
         ) {
            self.apiClient = apiClient
            self.userDefaults = userDefaults
         }

         func refreshProfileData() async throws -> (PaginatedResponse<Movie>, PaginatedResponse<Movie>) {
            async let favorites = apiClient.apiRequest(.favorites(sessionID: userDefaults.sessionID ?? "") as Endpoint<PaginatedResponse<Movie>>)
            async let watchlist = apiClient.apiRequest(.watchlist(sessionID: userDefaults.sessionID ?? "") as Endpoint<PaginatedResponse<Movie>>)
            let response = try await (favorites, watchlist)
            self.favorites = response.0.results
            self.watchlist = response.1.results
            return response
         }
      }

      let session = Session(apiClient: apiClient, userDefaults: userDefaults)

      return .init { try await apiClient.apiRequest(.addToFavorite() as Endpoint<ResponseModel>, payload: $0) }
      addToWatchlist: { try await apiClient.apiRequest(.addToWatchlist() as Endpoint<ResponseModel>, payload: $0) }
      favoriteMovies: { await session.favorites }
      fetchRequestToken: { try await apiClient.apiRequest(.requestToken() as Endpoint<SessionToken>) }
      fetchSessionID: { try await apiClient.apiRequest(.sessionID() as Endpoint<UserSession>, payload: $0) }
      refreshProfileData: { try await session.refreshProfileData() }
      watchlist: { await session.watchlist }
   }
}

extension DependencyValues {
   var userClient: UserClient {
      get { self[UserClient.self] }
      set { self[UserClient.self] = newValue }
   }
}
