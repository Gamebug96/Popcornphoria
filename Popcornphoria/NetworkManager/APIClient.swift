//
//  APIClient.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 25/03/24.
//

import ComposableArchitecture
import Dependencies
import Foundation
import os

extension DependencyValues {
   var apiClient: APIClient {
      get { self[APIClient.self] }
      set { self[APIClient.self] = newValue }
   }
}

enum APIError: Error, LocalizedError {
   case authenticationError
   case badRequest
   case custom(_ error: String)
   case invalidURL
}

@DependencyClient
struct APIClient {
   var apiRequest: @Sendable (URLRequest) async throws -> (Data, URLResponse)

   func apiRequest<ResponseType: Codable, Payload: Encodable>(
      _ endpoint: Endpoint<ResponseType>,
      payload: Payload
   ) async throws -> ResponseType {
      try await realRequest(endpoint, payload: payload)
   }

   func apiRequest<ResponseType: Codable>(
      _ endpoint: Endpoint<ResponseType>
   ) async throws -> ResponseType {
      try await realRequest(endpoint, payload: nil as String?)
   }

   private func realRequest<ResponseType: Codable, Payload: Encodable>(
      _ endpoint: Endpoint<ResponseType>,
      payload: Payload? = nil
   ) async throws -> ResponseType {
      guard let url = endpoint.url else {
         throw APIError.invalidURL
      }

      var request = URLRequest(url: url)
      request.addValue("application/json;version=2.0", forHTTPHeaderField: "Accept")

      print("API Request URL: \(request)")

      if let payload = payload {
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         let encoder = JSONEncoder()
         encoder.keyEncodingStrategy = .convertToSnakeCase
         request.httpBody = try? encoder.encode(payload)
         
         print("API Request Parameters: \(String(data: request.httpBody!, encoding: .utf8)!)")
      }

      let (data, response) = try await apiRequest(request)
      print("API Response: \(String(data: data, encoding: .utf8) ?? "")")
      return try await APIResponse().decode(data: data, response: response)
   }
}

extension Task where Failure == Never {
   /// An async function that never returns.
   static func never() async throws -> Success {
      for await element in AsyncStream<Success>.never {
         return element
      }
      throw _Concurrency.CancellationError()
   }
}

extension AsyncStream {
   static var never: Self {
      Self { _ in }
   }
}

extension APIClient: DependencyKey {
   static var liveValue = Self {
      try await URLSession.shared.data(for: $0)
   }
}

//extension DependencyValues {
//   public var apiClient: ApiClient2 {
//      get { self[ApiClient2.self] }
//      set { self[ApiClient2.self] = newValue }
//   }
//}
//
//extension ApiClient2: TestDependencyKey {
//   public static let previewValue = Self()
//   public static let testValue = Self()
//}
