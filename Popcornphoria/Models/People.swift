//
//  People.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 07/04/24.
//

import Foundation

extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

struct CreditsResponse: Codable, Equatable {
    let id: Int
    let cast: [People]
    let crew: [People]
}

struct PeopleCreditsResponse: Codable, Equatable {
    let cast: [Movie]?
    let crew: [Movie]?
}

struct People: Codable, Identifiable, Equatable, Hashable {
   func hash(into hasher: inout Hasher) {
      hasher.combine(id)
   }

   let id: Int
   let name: String
   var character: String?
   var department: String?
   let profilePath: String?
   let knownForDepartment: String?
   var knownFor: [KnownFor]?
   let alsoKnownAs: [String]?
   let birthDay: String?
   let deathDay: String?
   let placeOfBirth: String?
   let biography: String?
   let popularity: Double?
   var images: [ImageData]?

   struct KnownFor: Codable, Identifiable, Equatable {
      let id: Int
      let originalTitle: String?
      let posterPath: String?

      enum CodingKeys: String, CodingKey {
         case id
         case originalTitle = "original_title"
         case posterPath = "poster_path"
      }
   }
}

extension People {
   var knownForText: String? {
      guard let knownFor = knownFor else {
         return nil
      }
      let names = knownFor.filter{ $0.originalTitle != nil}.map{ $0.originalTitle! }
      return names.joined(separator: ", ")
   }
}

extension People {
   static let stub1 = People(
      id: 0,
      name: "Cast 1",
      character: "Character 1",
      department: nil,
      profilePath: "/2daC5DeXqwkFND0xxutbnSVKN6c.jpg",
      knownForDepartment: "Acting",
      knownFor: [.init(id: Movie.stub.id,
                       originalTitle: Movie.stub.originalTitle,
                       posterPath: Movie.stub.posterPath)],
      alsoKnownAs: nil,
      birthDay: nil,
      deathDay: nil,
      placeOfBirth: nil,
      biography: nil,
      popularity: nil,
      images: nil
   )

   static let stub2 = People(
      id: 1,
      name: "Cast 2",
      character: nil,
      department: "Director 1",
      profilePath: "/2daC5DeXqwkFND0xxutbnSVKN6c.jpg",
      knownForDepartment: "Acting",
      knownFor: nil,
      alsoKnownAs: nil,
      birthDay: nil,
      deathDay: nil,
      placeOfBirth: nil,
      biography: nil,
      popularity: nil,
      images: nil
   )
}
