//
//  ContinousCorner+ViewModifier.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 21/04/24.
//

import SwiftUI

extension View {
   func continuousCornerRadius(_ radius: CGFloat) -> some View {
      self.clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
   }
}
