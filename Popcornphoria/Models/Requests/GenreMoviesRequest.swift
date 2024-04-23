//
//  GenreMoviesRequest.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 16/04/24.
//

import Foundation

struct GenreMoviesRequest: Encodable {
   let withGenres: String
   let page = "1"
   let sortBy = "release_date.desc"
}
