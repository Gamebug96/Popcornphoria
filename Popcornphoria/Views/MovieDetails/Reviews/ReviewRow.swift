//
//  ReviewRow.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 14/04/24.
//

import SwiftUI

struct ReviewRow : View {
   let review: Review

   var body: some View {
      VStack(alignment: .leading, spacing: 8) {
         Text("Review written by \(review.author)")
            .font(.subheadline)
            .fontWeight(.bold)
            .lineLimit(1)
         Text(review.content)
            .font(.body)
            .lineLimit(nil)
      }
      .padding(.vertical)
   }
}

#Preview {
   ReviewRow(review: .stub)
}
