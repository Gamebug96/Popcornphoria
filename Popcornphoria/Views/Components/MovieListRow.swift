//
//  MovieListRow.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 24/03/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct MovieListRow: View {
   let movie: Movie

   var body: some View {
      content()
   }

   // MARK: - Displaying Contents

   @ViewBuilder
   private func content() -> some View {
      HStack(alignment: .top) {
         imageView()
         VStack(alignment: .leading) {
            titleView()
            HStack {
               PopularityBadge(score: Int(movie.voteAverage * 10))
               releaseDateView()
            }
            movieOverviewView()
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
         .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.45)
         .clipped()
         .clipShape(RoundedRectangle(cornerRadius: 10))
   }

   private func titleView() -> some View {
      Text(movie.title)
         .titleStyle()
         .foregroundStyle(Color.yellowSwatch2)
         .lineLimit(2)
   }

   private func releaseDateView() -> some View {
      Text(movie.formattedReleaseDate)
          .font(.subheadline)
          .foregroundColor(.white)
          .lineLimit(1)
   }

   private func movieOverviewView() -> some View {
      Text(movie.overview)
          .foregroundColor(.gray)
          .lineLimit(3)
          .truncationMode(.tail)
   }
}

#Preview {
   MovieListRow(movie: .stub)
}
