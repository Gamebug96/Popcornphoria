//
//  PopcornphoriaApp.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 23/03/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct PopcornphoriaApp: App {
   
   init() {
      NavigationAppearance.setupApperance()
   }
   
   var body: some Scene {
      WindowGroup {
         ContentView(
            store: Store(initialState: AppFeature.State(), reducer: {
               AppFeature()
            })
         )
      }
   }
}
