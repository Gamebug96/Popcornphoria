//
//  BorderedButton.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 05/04/24.
//

import SwiftUI

struct BorderedButton : View {
   let configuration: ButtonConfiguration

   var body: some View {
      Button(action: {
         configuration.completion?()
      }, label: {
         HStack(alignment: .center, spacing: 4) {
            configuration.image
               .foregroundColor(
                  configuration.isHighlighted
                     ? .white
                     : configuration.color
               )
            Text(configuration.text)
               .foregroundColor(
                  configuration.isHighlighted
                     ? .white
                     : configuration.color
               )
         }
      })
      .buttonStyle(BorderlessButtonStyle())
      .padding(6)
      .background(
         RoundedRectangle(cornerRadius: 8)
            .stroke(
               configuration.color,
               lineWidth: configuration.isHighlighted ? 0 : 2
            )
            .background(
               configuration.isHighlighted
                  ? configuration.color
                  : .clear
            )
            .cornerRadius(8)
      )
   }
}

#Preview {
   VStack {
      BorderedButton(configuration: .favorite {
      })
      BorderedButton(configuration: .watchlist {
      })
   }
}
