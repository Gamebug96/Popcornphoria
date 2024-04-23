//
//  MovieBackgroundPhoto.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 05/04/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct MovieBackgroundPhoto: View {
   let image: String

   var body: some View {
      content()
   }

   @ViewBuilder
   private func content() -> some View {
      ZStack {
         WebImage(url: ImageSize.medium.path(poster: image)) { image in
            image
               .resizable()
               .frame(width: UIScreen.main.bounds.width - 30, height: 220)
               .scaledToFill()
               .blur(radius: 50, opaque: true)
               .overlay(Color.black.opacity(0.2))
         } placeholder: {
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.3)
                .frame(height: 220)
         }
         .indicator(.activity)
         .transition(.fade(duration: 0.5))
      }
   }
}

#Preview {
   MovieBackgroundPhoto(image: "")
}
