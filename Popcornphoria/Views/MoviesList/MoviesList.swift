//
//  HomeView.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 24/03/24.
//

import ComposableArchitecture
import SwiftUI

struct MoviesList: View {
   @Bindable var store: StoreOf<MoviesListFeature>

   var body: some View {
      content()
         .background(.appBackground)
         .navigationTitle("Movies List")
         .navigationBarTitleDisplayMode(.inline)
         .onAppear(perform: {
            store.send(.fetchGenres)
         })
   }

   @ViewBuilder
   private func content() -> some View {
      ZStack {
         VStack {
            MoviesMenuView(selectedMenu: $store.selectedMenu.sending(\.menuSelected))
               .frame(height: 50)
            moviesList()
         }

         if store.isLoading {
            AppLoader()
         }
      }
   }

   private func moviesList() -> some View {
      List {
         ForEach(store.movies) { movie in
            NavigationLink(
               state: AppFeature.Path.State.movieDetail(MovieDetailFeature.State(movie: movie))
            ) {
               MovieListRow(movie: movie)
                  .listRowBackground(Color.appBackground)
            }
         }
      }
      .listStyle(.inset)
      .background(.appBackground)
      .scrollContentBackground(.hidden)
   }
}

#Preview {
   NavigationStack {
      MoviesList(
         store: Store(initialState: MoviesListFeature.State(),
                      reducer: {
                         MoviesListFeature()
                      })
      )
   }
}
