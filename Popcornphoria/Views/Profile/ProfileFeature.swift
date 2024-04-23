//
//  ProfileFeature.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 21/04/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ProfileFeature {
   @ObservableState
   struct State: Equatable {
      var favorites = [Movie]()
      var watchlist = [Movie]()
   }

   enum Action {
      case dataRefereshed(_ favorites: [Movie], _ watchlist: [Movie])
      case task
   }

   @Dependency(\.userClient.refreshProfileData) var refreshProfileData

   var body: some ReducerOf<Self> {
      Reduce { state, action in
         switch action {
         case .dataRefereshed(let favorites, let watchlist):
            state.favorites = favorites
            state.watchlist = watchlist
            return .none
         case .task:
            return .run { send in
               let (favoriteMovies, watchlist) = try await refreshProfileData()
               await send(.dataRefereshed(favoriteMovies.results, watchlist.results))
            }
         }
      }
   }
}
