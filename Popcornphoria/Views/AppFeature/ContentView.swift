//
//  ContentView.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 23/03/24.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
   @Bindable var store: StoreOf<AppFeature>

   var body: some View {
      NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
         rootView()
      } destination: { store in
         switch store.case {
         case .genreMovies(let store):
            GenreMovieListing(store: store)
         case .movieDetail(let store):
            MovieDetailsView(store: store)
         case .reviews(let store):
            ReviewsView(store: store)
         }
      }
   }

   @ViewBuilder
   private func rootView() -> some View {
      switch store.state.appState {
      case .authorized:
         TabView {
            MoviesList(
               store: store.scope(
                  state: \.moviesList,
                  action: \.moviesList
               )
            )
            .tag(AppFeature.Tab.moviesList)
            .tabItem {
               VStack {
                  Image(systemName: "house.fill")
                  Text("Home")
               }
            }

            ProfileView(
               store: store.scope(
                  state: \.userProfile,
                  action: \.userProfile
               )
            )
            .tag(AppFeature.Tab.profile)
            .tabItem {
               VStack {
                  Image(systemName: "person.fill")
                  Text("Profile")
               }
            }
         }
      case .error(let error):
         errorView(error)
      case .isLoading:
         ZStack {
            Color.black
            AppLoader()
         }.ignoresSafeArea()
      case .notAuthorized:
         Color.black
            .ignoresSafeArea()
            .task { store.send(.task) }
      case .webAuthorization(let url):
         if let url {
            WebView(url: url, content: .tokenValidation) {
               store.send(.tokenVerified)
            }
         } else {
            EmptyView()
         }
      }
   }

   private func errorView(_ error: String) -> some View {
      VStack {
         Text("Oops! Received an Error")
         Text(error)
      }
      .titleStyle()
      .padding(.horizontal, 25)
   }
}

#Preview {
   ContentView(store: .init(initialState: AppFeature.State(), reducer: {
      AppFeature()
   }))
}
