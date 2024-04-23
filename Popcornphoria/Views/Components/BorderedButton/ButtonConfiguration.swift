//
//  ButtonConfiguration.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 05/04/24.
//

import SwiftUI

/// A configuration object for an `BorderedButton`
struct ButtonConfiguration {
   typealias CompletionBlock = () -> Void

   let text: String
   let image: Image
   let color: Color
   let isHighlighted: Bool
   var completion: CompletionBlock?
}

extension ButtonConfiguration {
   static func favorite(completion: @escaping CompletionBlock) -> Self {
      .init(text: "Favorite",
            image: .init(systemName: "heart"),
            color: .pink,
            isHighlighted: false,
            completion: completion)
   }

   static func watchlist(completion: @escaping CompletionBlock) -> Self {
      .init(text: "Watchlist",
            image: .init(systemName: "eye"),
            color: .green,
            isHighlighted: false,
            completion: completion)
   }
}
