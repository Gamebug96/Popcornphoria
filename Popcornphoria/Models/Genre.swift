//
//  Genre.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 09/04/24.
//

import Foundation

struct GenreResponse: Codable {
   let genres: [Genre]
}

struct Genre: Codable, Identifiable, Equatable {
   let id: Int
   let name: String
}
