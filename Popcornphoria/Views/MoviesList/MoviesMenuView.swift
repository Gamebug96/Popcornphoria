//
//  MoviesMenu.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 30/03/24.
//

import SwiftUI

struct MoviesMenuView: View {
   @Binding var selectedMenu: MoviesMenu

   var body: some View {
      content()
   }

   @ViewBuilder
   private func content() -> some View {
      ScrollView(.horizontal, showsIndicators: false) {
         LazyHStack(spacing: 2) {
            ForEach(MoviesMenu.allCases) { menu in
               menuButton(menu)
               if menu != MoviesMenu.allCases.last {
                  Text("|").foregroundStyle(Color.gray.opacity(0.5))
               }
            }
         }
      }
   }

   private func menuButton(_ menu: MoviesMenu) -> some View {
      Button {
         selectedMenu = menu
      } label: {
         ZStack {
            if selectedMenu == menu {
               RoundedRectangle(cornerRadius: 8)
                  .fill(.yellowSwatch2)
            }

            Text(menu.title)
               .font(.footnote.bold())
               .foregroundColor(.white)
         }.frame(width: UIScreen.main.bounds.width * 0.25, height: 36)
      }
   }
}

#Preview {
   ZStack {
      Color.black.ignoresSafeArea()
      MoviesMenuView(selectedMenu: .constant(.nowPlaying))
   }
}
