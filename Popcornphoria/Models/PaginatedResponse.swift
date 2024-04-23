//
//  PaginatedResponse.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 25/03/24.
//

import Foundation

struct PaginatedResponse<T: Codable & Equatable>: Codable, Equatable {
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    var results: [T]
}
