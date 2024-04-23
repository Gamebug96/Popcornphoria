//
//  Interface.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 21/04/24.
//

import ComposableArchitecture
import SwiftUI

extension DependencyValues {
   var userDefaults: UserDefaultsClient {
      get { self[UserDefaultsClient.self] }
      set { self[UserDefaultsClient.self] = newValue }
   }
}

@Reducer
struct UserDefaultsClient {
   var stringForKey: @Sendable (String) -> String?
   var setString: @Sendable (String, String) async -> Void

   var sessionID: String? {
      self.stringForKey(sessionIDKey)
   }

   func setSessionID(_ id: String) async {
      await self.setString(id, sessionIDKey)
   }
}

let sessionIDKey = "sessionIDkey"

