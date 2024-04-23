//
//  MovieDetailsView.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 31/03/24.
//

import ComposableArchitecture
import SDWebImageSwiftUI
import SwiftUI

struct MovieDetailsView: View {
   var store: StoreOf<MovieDetailFeature>

   var body: some View {
      content()
         .background(Color.appBackground)
         .clipShape(RoundedRectangle(cornerRadius: 10))
         .navigationTitle(store.movie.title)
         .navigationBarTitleDisplayMode(.large)
         .task { store.send(.task) }
   }

   @ViewBuilder
   private func content() -> some View {
      List {
         topSection()
         bottomSection()
      }.listStyle(.insetGrouped)
   }

   private func topSection() -> some View {
      Section {
         MovieCoverView(movie: store.movie)
         MovieDetailButtonsRow().padding(.bottom, 10)
         if store.reviews.count > 0 {
            NavigationLink(
               state: AppFeature.Path.State.reviews(ReviewsFeature.State(movieID: store.state.movie.id))
            ) {
               Text("\(store.reviews.count) reviews")
                  .foregroundColor(.blueSwatch1)
                  .lineLimit(1)
            }
         }
         movieOverview()
      }
   }

   private func movieOverview() -> some View {
      VStack(alignment: .leading, spacing: 8) {
         Text("Overview:")
            .titleStyle()
            .lineLimit(1)
         Text(store.movie.overview)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(store.isOverviewExpanded ? nil : 4)
            .onTapGesture {
               store.send(.expandOverview, animation: .easeInOut)
            }
         Button(action: {
            store.send(.expandOverview, animation: .easeInOut)
         }, label: {
            Text(store.isOverviewExpanded ? "Less" : "Read more")
               .lineLimit(1)
               .foregroundColor(.blueSwatch1)
         })
      }
   }

   private func bottomSection() -> some View {
      Section {
         if
            let keywords = store.movie.keywords?.keywords,
            !keywords.isEmpty {
            MovieKeywords(keywords: keywords)
         }

         if !store.casts.isEmpty {
            MovieCrosslinePeopleRow(title: "Cast", peoples: store.casts)
         }

         if let director = store.director {
            peopleRow(director, role: "Director")
         }
      }
   }

   private func peopleRow(_ people: People, role: String) -> some View {
      HStack(alignment: .center, spacing: 0) {
          Text(role + ": ").font(.callout)
          Text(people.name).font(.body).foregroundColor(.secondary)
      }
   }
}

#Preview {
   MovieDetailsView(
      store: .init(
         initialState: MovieDetailFeature.State(
            movie: .stub,
            casts: [.stub1, .stub2],
            reviews: [.stub]
         ),
         reducer: {
            MovieDetailFeature()
         }
      )
   )
}
