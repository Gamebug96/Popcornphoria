//
//  ReviewsView.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 06/04/24.
//

import ComposableArchitecture
import SwiftUI

struct ReviewsView: View {
   let store: StoreOf<ReviewsFeature>
   
   var body: some View {
      List(store.reviews.results) {
         ReviewRow(review: $0)
      }
      .listStyle(.insetGrouped)
      .navigationTitle("Reviews")
      .onAppear(perform: {
         store.send(.didAppear)
      })
   }
}

#Preview {
   ReviewsView(store: .init(initialState: ReviewsFeature.State(movieID: Movie.stub.id), reducer: {
      ReviewsFeature()
   }))
}
