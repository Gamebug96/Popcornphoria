//
//  LiveKey.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 21/04/24.
//

import ComposableArchitecture
import Foundation

extension UserDefaultsClient: DependencyKey {
   static let liveValue: Self = {
      let defaults = { UserDefaults(suiteName: "group.popcornphoria")! }
      return Self(
         stringForKey: { defaults().string(forKey: $0) },
         setString: { defaults().set($0, forKey: $1) }
      )
   }()
}
