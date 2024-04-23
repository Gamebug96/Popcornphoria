//
//  MovieCoverView.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 05/04/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct MovieCoverView: View {
   let movie: Movie

   var body: some View {
      content()
   }

   @ViewBuilder
   private func content() -> some View {
      ZStack {
         MovieBackgroundPhoto(image: movie.backdropPath ?? movie.posterPath ?? "")

         VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 15) {
               imageView()
               VStack(alignment: .leading, spacing: 15) {
                  MovieInfoView(movie: movie)
                  if let country = movie.productionCountries?.first {
                     Text(country.name).fontWeight(.medium)
                  }
                  HStack {
                     PopularityBadge(score: Int(movie.voteAverage * 10))
                     Text("\(movie.voteCount) ratings").fontWeight(.medium)
                  }
               }
            }
            .padding(.leading, 25)
            .frame(maxWidth: .infinity, alignment: .leading)

            genreList()
         }
      }
   }

   private func imageView() -> some View {
      WebImage(url: ImageSize.medium.path(poster: movie.posterPath ?? ""))
         .resizable()
         .indicator { _, _ in
            ProgressView()
         }
         .scaledToFill()
         .frame(width: 100, height: 150)
         .clipped()
         .clipShape(RoundedRectangle(cornerRadius: 10))
   }

   private func genreList() -> some View {
      ScrollView(.horizontal, showsIndicators: false) {
          HStack {
              ForEach(movie.genres ?? []) { genre in
                 NavigationLink(
                  state: AppFeature.Path.State.genreMovies(GenreMoviesListingFeature.State(genre: genre))
                 ) {
                    RoundedBadge(text: genre.name, color: .appBackground)
                 }
              }
          }
          .padding(.horizontal, 25)
          .redacted(reason: movie.genres == nil ? .placeholder : [])
      }
   }
}

#Preview {
   MovieCoverView(movie: .stub)
}
