//
//  MovieInfoView.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 05/04/24.
//

import SwiftUI

struct MovieInfoView: View {
   let movie: Movie

   var asyncTextTransition: AnyTransition {
      .opacity
   }

   var asyncTextAnimation: Animation {
      .easeInOut
   }

   var body: some View {
      VStack(alignment: .leading, spacing: 8) {
         infos
      }
   }

   private var infos: some View {
      HStack {
         if let date = movie.releaseDate {
            Text(date.prefix(4)).font(.subheadline)
         }
         if let runtime = movie.runtime {
            Text("• \(runtime) minutes")
               .font(.subheadline)
               .animation(asyncTextAnimation)
               .transition(asyncTextTransition)
         }
         if let status = movie.status {
            Text("• \(status)")
               .font(.subheadline)
               .animation(asyncTextAnimation)
               .transition(asyncTextTransition)
         }
      }
      .fontWeight(.medium)
      .foregroundColor(.white)
   }
}

#Preview {
   MovieInfoView(movie: .stub).background(Color.black)
}
