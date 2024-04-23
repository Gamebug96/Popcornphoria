//
//  RoundedBadge.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 05/04/24.
//

import SwiftUI

struct RoundedBadge: View {
    let text: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(text.capitalized)
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.leading, 10)
                .padding([.top, .bottom], 5)
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 5, height: 10)
                .foregroundColor(.primary)
                .padding(.trailing, 10)
            
            }
            .background(
                Rectangle()
                    .foregroundColor(color)
                    .cornerRadius(12)
        )
            .padding(.bottom, 4)
    }
}

#Preview {
   RoundedBadge(text: "Test", color: .blue)
}
