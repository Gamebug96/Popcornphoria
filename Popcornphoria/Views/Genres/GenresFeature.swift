//
//  GenresFeature.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 22/04/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct GenresFeature {
   @ObservableState
   struct State: Equatable {
      var genres = PaginatedResponse<Genre>(
         page: 1,
         total_results: nil,
         total_pages: nil,
         results: []
      )
   }

   enum Action {
      case task
   }

   var body: some ReducerOf<Self> {
      Reduce { state, action in
         switch action {
         case .task:
            return .none
         }
      }
   }
}
