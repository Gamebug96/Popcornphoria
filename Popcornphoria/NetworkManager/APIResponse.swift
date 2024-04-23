//
//  APIResponse.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 25/03/24.
//

import Foundation

struct APIResponse {
   /// `ResponseResult` describes the result returned by the `handleResponse` function
   private enum ResponseResult<String> {
      /// Success case if the status code return by the API is valid
      case success
      /// Returns an error description with the failure case
      case failure(String)
   }

   /// Private function to validate the status code returned by the API
   /// - parameter response: HTTPURLResponse given by the API
   /// - returns: `ResponseResult` i.e either `success` or `failure` with error description
   private func handleResponse(_ response: HTTPURLResponse, and data: Data) -> ResponseResult<APIError> {
      switch response.statusCode {
      case 200...299, 302:
         return .success
      case 401...403:
         return .failure(.authenticationError)
      case 500...599:
         return .failure(.badRequest)
      default:
         return .failure(.custom("Something went wrong"))
      }
   }

   /// Checks for valid API response and decodes the data into the `ResponseType` decodable object
   ///
   /// - Parameters:
   ///   - data: Raw data provided by the API
   ///   - response: URLResponse provided by the API
   ///
   /// - Returns: Result type if either success case if decoded successfully or a failure case with an error description
   func decode<ResponseType: Decodable>(data: Data, response: URLResponse) async throws -> ResponseType {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .millisecondsSince1970
      decoder.keyDecodingStrategy = .convertFromSnakeCase

      do {
         let responseValues = try decoder.decode(ResponseType.self, from: data)

         if let response = response as? HTTPURLResponse {
            let result = handleResponse(response, and: data)
            switch result {
            case .success:
               return responseValues
            case .failure(let error):
               throw error
            }
         } else {
            return responseValues
         }
      } catch {
         debugPrint(error)
         throw error
      }
   }
}

