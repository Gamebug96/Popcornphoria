//
//  ScaledFont.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 24/03/24.
//

import SwiftUI

enum Fonts: String {
   case fjallaOne = "FjallaOne-Regular"
}

private let sizeMap: [UIFont.TextStyle: CGFloat] = [
   .largeTitle: 34,
   .title1: 28,
   .title2: 22,
   .title3: 20,
   .headline: 17,
   .body: 17,
   .callout: 16,
   .subheadline: 15,
   .footnote: 13,
   .caption1: 12,
   .caption2: 11
]

/// A convenience class for obtaining scalable (Dynamic Type) fonts.
final class ScaledUIFont {
   
   private let fontName: String
   
   private init(fontName: String) {
      self.fontName = fontName
   }
   
   /// Returns an instance of the receiver's font for the specified text style, scaled for the user's selected content size category.
   /// - Parameter textStyle: The text style for which to return a font.
   /// - Returns: A scalable font associated with the specified text style.
   func font(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
      guard
         let size = sizeMap[textStyle],
         let font = UIFont(name: fontName, size: size) else {
         return UIFont.preferredFont(forTextStyle: textStyle)
      }
      
      let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
      return fontMetrics.scaledFont(for: font)
   }
   
   static var fjallaOne = ScaledUIFont(fontName: Fonts.fjallaOne.rawValue)
}

struct ScaledFont: ViewModifier {
   @Environment(\.sizeCategory) var sizeCategory
   
   var name: Fonts
   var style: UIFont.TextStyle
   var weight: Font.Weight = .regular
   
   func body(content: Content) -> some View {
      return content.font(Font.custom(
         name.rawValue,
         size: UIFont.preferredFont(forTextStyle: style).pointSize)
         .weight(weight))
   }
}

extension View {
   func scaledFont(
      name: Fonts,
      style: UIFont.TextStyle,
      weight: Font.Weight = .regular) -> some View {
         return self.modifier(ScaledFont(name: name, style: style, weight: weight))
      }
}

struct TitleFont: ViewModifier {
   func body(content: Content) -> some View {
      return content.scaledFont(name: .fjallaOne, style: .callout)
   }
}

extension View {
   func titleStyle() -> some View {
      return ModifiedContent(content: self, modifier: TitleFont())
   }
}
