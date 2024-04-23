//
//  MovieDetailButtonRow.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 05/04/24.
//

import SwiftUI

struct MovieDetailButtonsRow: View {
   var body: some View {
      HStack(alignment: .center, spacing: 8) {
         BorderedButton(configuration: .favorite {
            
         })

         BorderedButton(configuration: .watchlist {
         })
      }
   }
}

#Preview {
   MovieDetailButtonsRow()
}
