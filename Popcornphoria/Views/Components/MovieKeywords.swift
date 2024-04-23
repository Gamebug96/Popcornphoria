//
//  MovieKeywords.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 07/04/24.
//

import SwiftUI

struct MovieKeywords: View {
   let keywords: [Keyword]

   var body: some View {
      VStack(alignment: .leading, spacing: 8) {
         Text("Keywords")
            .titleStyle()
            .padding(.leading)

         ScrollView(.horizontal, showsIndicators: false) {
            HStack {
               ForEach(keywords) { keyword in
                  RoundedBadge(text: keyword.name, color: .appBackground)
               }
            }.padding(.leading)
         }
      }
      .listRowInsets(EdgeInsets())
      .padding(.vertical)
   }
}

#Preview {
   MovieKeywords(keywords: [Keyword(id: 0, name: "Test")])
}
