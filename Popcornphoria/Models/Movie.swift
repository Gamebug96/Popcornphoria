//
//  Movie.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 24/03/24.
//

import Foundation

struct Movie: Codable, Identifiable, Equatable, Sendable {
   let id: Int
   let originalTitle: String
   let title: String
   let overview: String
   let posterPath: String?
   let backdropPath: String?
   let popularity: Float
   let voteAverage: Float
   let voteCount: Int
   let releaseDate: String?
   let genreIds: [Int]?
   var genres: [Genre]?
   let runtime: Int?
   let status: String?
   let video: Bool
   var keywords: Keywords?
   var images: MovieImages?
   var productionCountries: [ProductionCountry]?
   var character: String?
   var department: String?
   var isFavorite = false
   var isInWatchlist = false

   var dateFormatter: DateFormatter {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyy-MM-dd"
       return formatter
   }
   
   var formattedReleaseDate: String {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      return formatter.string(
         from: dateFormatter.date(from: releaseDate ?? "") ?? Date()
      )
   }

   struct Keywords: Codable, Equatable {
      let keywords: [Keyword]?
   }
   
   struct MovieImages: Codable, Equatable {
      let posters: [ImageData]?
      let backdrops: [ImageData]?
   }
   
   struct ProductionCountry: Codable, Identifiable, Equatable {
      var id: String {
         name
      }
      let name: String
   }

   enum CodingKeys: String, CodingKey {
      case id
      case originalTitle
      case title
      case overview
      case posterPath
      case backdropPath
      case popularity
      case voteAverage
      case voteCount
      case releaseDate
      case genreIds
      case genres
      case runtime
      case status
      case video
      case keywords
      case images
      case productionCountries
      case character
      case department
   }
}

extension Movie {
   static let stub = Movie(id: 0,
                           originalTitle: "Test movie Test movie Test movie Test movie Test movie Test movie Test movie ",
                           title: "Test movie Test movie Test movie Test movie Test movie Test movie Test movie  Test movie Test movie Test movie",
                           overview: "Test movie Test movie Test movie Test movie Test movie Test movie Test movie  Test movie Test movie Test movie Test movie Test movie Test movie Test movie Test movie Test movie Test movie  Test movie Test movie Test movie Test movie Test movie Test movie Test movie Test movie Test movie Test movie  Test movie Test movie Test movie",
                           posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
                           backdropPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
                           popularity: 50.5,
                           voteAverage: 8.9,
                           voteCount: 1000,
                           releaseDate: "1972-03-14",
                           genreIds: nil,
                           genres: [Genre(id: 0, name: "test")],
                           runtime: 80,
                           status: "released",
                           video: false,
                           keywords: .init(keywords: [.init(id: 0, name: "Testing")]))
}

struct ImageData: Codable, Identifiable, Equatable {
   var id: String {
      file_path
   }
   let aspectRatio: Float
   let file_path: String
   let height: Int
   let width: Int
}

struct Keyword: Codable, Identifiable, Equatable {
   let id: Int
   let name: String
}

enum ImageSize: String {
   case small = "https://image.tmdb.org/t/p/w154"
   case medium = "https://image.tmdb.org/t/p/w500"
   case cast = "https://image.tmdb.org/t/p/w185"
   case original = "https://image.tmdb.org/t/p/original"
   
   func path(poster: String) -> URL {
      return URL(string: rawValue)!.appendingPathComponent(poster)
   }
}
