//
//  Endpoint.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 25/03/24.
//

import Foundation

/// A struct for defining and generating API endpoint URLs
struct Endpoint<ResponseType> {
   private let path: Path
   private let queryItems: [URLQueryItem]
   
   init(path: Path, queryItems: [URLQueryItem] = []) {
      self.path = path
      self.queryItems = queryItems
   }
   
   /// Returns a copy of the receiver with the `page` query item incremented by 1
   /// - Returns: An Endpoint
   func next() -> Endpoint {
      let newQueryItems: [URLQueryItem] = self.queryItems
         .map {
            if $0.name == "page" {
               guard let currentPageString = $0.value,
                     let currentPage = Int(currentPageString) else {
                  return $0
               }
               return URLQueryItem(name: $0.name, value: String(currentPage + 1))
            } else {
               return $0
            }
         }
      return Self(path: path, queryItems: newQueryItems)
   }
}

extension Endpoint {
   /// Path definitions
   enum Path {
      case addToFavorite
      case addToWatchlist
      case credits(_ movideID: Int)
      case discover
      case favorites
      case genreList
      case movies(_ menu: String)
      case recommendedMovies(_ movieID: Int)
      case requestToken
      case reviews(_ movieID: Int)
      case sessionID
      case similarMovie(_ movieID: Int)
      case watchlist

      var asString: String {
         switch self {
         case .addToFavorite:
            return "account/:account_id/favorite"
         case .addToWatchlist:
            return ""
         case .credits(let movieID):
            return "movie/\(String(movieID))/credits"
         case .discover:
            return "discover/movie"
         case .genreList:
            return "/genre/movie/list"
         case .favorites:
            return "account/\(Constants.accountID)/favorite/movies"
         case .movies(let menu):
            return "\(menu)"
         case .recommendedMovies(let movieID):
            return "movie/\(String(movieID))/recommendations"
         case .requestToken:
            return "authentication/token/new"
         case .reviews(let movieID):
            return "movie/\(String(movieID))/reviews"
         case .sessionID:
            return "authentication/session/new"
         case .similarMovie(let movieID):
            return "movie/\(String(movieID))/similar"
         case .watchlist:
            return "account/\(Constants.accountID)/watchlist/movies"
         }
      }
   }
}

extension Endpoint {
   /// A convenience property for constructing a URL
   var url: URL? {
      var components = URLComponents()
      components.host = "api.themoviedb.org"
      let pathPrefix = "/3"
      components.scheme = "https"
      components.path = "\(pathPrefix)/\(path.asString)"
      var modifiedQueryItems = [
         URLQueryItem(name: "api_key", value: Constants.apiKey),
         URLQueryItem(name: "language", value: Locale.preferredLanguages[0])
      ]
      modifiedQueryItems.append(contentsOf: queryItems)
      components.queryItems = modifiedQueryItems
      
      return components.url
   }
}

extension Endpoint {
   static func addToFavorite() -> Self {
      .init(path: .addToFavorite)
   }
   
   static func addToWatchlist() -> Self {
      .init(path: .addToWatchlist)
   }
   
   static func credits(for movieID: Int) -> Self {
      .init(path: .credits(movieID))
   }

   static func discover(queryParams: GenreMoviesRequest) -> Self {
      .init(path: .discover, queryItems: [.init(name: "with_genres", value: queryParams.withGenres)])
   }

   static func favorites(sessionID: String) -> Self {
      .init(path: .favorites, queryItems: [.init(name: "session_id", value: sessionID)])
   }

   static func genreList() -> Self {
      .init(path: .genreList)
   }

   static func moviesList(for menu: String) -> Self {
      .init(path: .movies(menu), queryItems: [
         .init(name: "page", value: "1"),
         .init(name: "region", value: Locale.current.region?.identifier)
      ])
   }

   static func recommendedMovies(for movieID: Int) -> Self {
      .init(path: .recommendedMovies(movieID))
   }

   static func requestToken() -> Self {
      .init(path: .requestToken)
   }

   static func reviews(for movieID: Int) -> Self {
      .init(path: .reviews(movieID))
   }

   static func sessionID() -> Self {
      .init(path: .sessionID)
   }

   static func similarMovies(for movieID: Int) -> Self {
      .init(path: .similarMovie(movieID))
   }

   static func watchlist(sessionID: String) -> Self {
      .init(path: .watchlist, queryItems: [.init(name: "session_id", value: sessionID)])
   }
}
