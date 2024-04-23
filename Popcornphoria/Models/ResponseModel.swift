//
//  ResponseModel.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 20/04/24.
//

import Foundation

struct ResponseModel: Codable {
   let statusMessage: String
   let statusCode: Int
   let success: Bool
}
