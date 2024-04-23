//
//  NavigationAppearance.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 24/03/24.
//

import UIKit

struct NavigationAppearance {
   static func setupApperance() {
      UINavigationBar.appearance().largeTitleTextAttributes = [
         NSAttributedString.Key.foregroundColor: UIColor.yellowSwatch2,
         NSAttributedString.Key.font: ScaledUIFont.fjallaOne.font(forTextStyle: .largeTitle)]

      UINavigationBar.appearance().titleTextAttributes = [
         NSAttributedString.Key.foregroundColor: UIColor.yellowSwatch2,
         NSAttributedString.Key.font: ScaledUIFont.fjallaOne.font(forTextStyle: .body)]

      UIBarButtonItem.appearance().setTitleTextAttributes([
         NSAttributedString.Key.foregroundColor: UIColor.yellowSwatch2,
         NSAttributedString.Key.font: ScaledUIFont.fjallaOne.font(forTextStyle: .callout)],
                                                          for: .normal)

      UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = .yellowSwatch2
   }
}
