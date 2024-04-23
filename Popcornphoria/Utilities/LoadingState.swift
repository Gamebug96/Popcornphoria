//
//  LoadingState.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 14/04/24.
//

import SwiftUI

protocol LoadableObject: ObservableObject {
    associatedtype Output
    var state: LoadingState<Output> { get }
    func load()
}

enum LoadingState<Value> {
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
}
