//
//  MovieCrosslinePeopleView.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 07/04/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct MovieCrosslinePeopleRow: View {
   let title: String
   let peoples: [People]

   var body: some View {
      content()
   }

   @ViewBuilder
   private func content() -> some View {
      VStack(alignment: .leading) {
         headerView()
         peopleList()
      }
      .listRowInsets(EdgeInsets())
      .padding(.vertical)
   }

   private func headerView() -> some View {
      HStack {
         Text(title)
            .titleStyle()
            .padding(.leading)
         Text("See all").foregroundColor(.blueSwatch1)
      }
   }

   private func peopleList() -> some View {
      ScrollView(.horizontal, showsIndicators: false) {
         LazyHStack {
            ForEach(peoples) { cast in
               PeopleRowItem(people: cast)
            }
         }.padding(.leading)
      }
   }
}

struct PeopleRowItem: View {
   let people: People

   var body: some View {
      content()
   }

   @ViewBuilder
   private func content() -> some View {
      VStack(alignment: .center) {
         imageView()
         Text(people.name)
            .font(.footnote)
            .foregroundColor(.primary)
            .lineLimit(1)
         Text(people.character ?? people.department ?? "")
            .font(.footnote)
            .foregroundColor(.secondary)
            .lineLimit(1)
      }
      .frame(width: 100)
   }

   private func imageView() -> some View {
      WebImage(url: ImageSize.cast.path(poster: people.profilePath ?? "")) { image in
         image
            .resizable()
            .frame(width: 60, height: 90)
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 10))
      } placeholder: {
         Image("Placeholder")
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 90)
            .background(.graySwatch2)
            .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .indicator(.activity)
      .transition(.fade(duration: 0.5))
   }
}

#Preview {
   MovieCrosslinePeopleRow(
      title: "Sample",
      peoples: [.stub1, .stub2]
   )
}
