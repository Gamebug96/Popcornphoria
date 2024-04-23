//
//  Review.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 06/04/24.
//

import Foundation

struct Review: Codable, Identifiable, Equatable {
    let id: String
    let author: String
    let content: String
}

extension Review {
   static let stub: Self = .init(
      id: UUID().uuidString,
      author: "Gamebug",
      content: "The movie is good!!! It could be better if paid attention to small details but overall it is definitely worth a watch!"
   )
}
