//
//  GenreMovieListing.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 16/04/24.
//

import ComposableArchitecture
import SwiftUI

struct GenreMovieListing: View {
   let store: StoreOf<GenreMoviesListingFeature>

   var body: some View {
      moviesList()
         .navigationTitle(store.genre.name)
         .onAppear(perform: {
            store.send(.didAppear)
         })
   }

   private func moviesList() -> some View {
      List {
         ForEach(store.movies.results) { movie in
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
   GenreMovieListing(
      store: .init(initialState: GenreMoviesListingFeature.State(genre: .init(id: 0, name: "Thriller")), reducer: {
         GenreMoviesListingFeature()
      })
   )
}
