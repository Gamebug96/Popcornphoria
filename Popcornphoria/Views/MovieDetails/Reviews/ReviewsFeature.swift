//
//  ReviewsFeature.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 06/04/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ReviewsFeature {
   @ObservableState
   struct State: Equatable {
      let movieID: Int
      var reviews = PaginatedResponse<Review>(page: 1, total_results: nil, total_pages: nil, results: [])
   }

   enum Action {
      case didReceiveError(Error)
      case didAppear
      case reviewsFetched(PaginatedResponse<Review>)
   }

   @Dependency(\.movieClient) var movieClient

   var body: some ReducerOf<Self> {
      Reduce { state, action in
         switch action {
         case .didReceiveError(let error):
            print(error.localizedDescription)
            return .none
         case .didAppear:
            return .run { [movieID = state.movieID] send in
               let results = try await movieClient.fetchReviews(movieID: movieID)
               await send(.reviewsFetched(results))
            }
         case .reviewsFetched(let data):
            state.reviews = data
            return .none
         }
      }
   }
}
