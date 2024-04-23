//
//  ProfileView.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 20/04/24.
//

import ComposableArchitecture
import SwiftUI

struct ProfileView: View {
   let store: StoreOf<ProfileFeature>
   
   enum SavedData {
      case favorites
      case watchlist
   }

   var body: some View {
      content()
         .navigationTitle("")
   }

   // MARK: - Displaying Content

   @ViewBuilder
   private func content() -> some View {
      VStack {
         
      }
   }
}

#Preview {
   ProfileView(
      store: .init(
         initialState: ProfileFeature.State(),
         reducer: {
            ProfileFeature()
         }
      )
   )
}
