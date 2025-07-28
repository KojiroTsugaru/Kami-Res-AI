//
//  GenerateService.swift
//  kami-res-ai
//
//  Created by kj on 7/27/25.
//

import Foundation

/// Shared service to send an image to your `/generate-response` endpoint
class GenerateReplyService {
  static let shared = GenerateReplyService()
  private init() {}
  
  enum ServiceError: Error {
    /// URL couldn't be constructed
    case invalidURL
    /// Response was not HTTPURLResponse
    case invalidResponse
    /// HTTP status code outside 2xx
    case httpError(statusCode: Int)
    /// Decoding JSON failed
    case decodingError(Error)
  }
  
  /// Sends imageData to your local API and returns the parsed ChatCompletionResponse.
  /// - Parameters:
  ///   - imageData: raw image data
  ///   - mood: e.g. "casual"
  ///   - length: e.g. 1.0
  /// - Returns: decoded ChatCompletionResponse
  func generateReplyFromImage(replyRequest: GenerateReplyRequest) async throws -> ChatCompletionResponse {
    
    // make url
    guard let url = URL(string: "\(Env.apiBaseURL)/generate-response") else {
      throw ServiceError.invalidURL
    }
    
    // Configure request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Prepare JSON body、
    let payload: [String: Any] = [
      "mood": replyRequest.mood,
      "length": replyRequest.length,
      "image_base64": replyRequest.imageData.base64EncodedString()
    ]
    request.httpBody = try JSONSerialization.data(
      withJSONObject: payload,
      options: []
    )
    
    // Perform network call
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let http = response as? HTTPURLResponse else {
      throw ServiceError.invalidResponse
    }
    guard (200...299).contains(http.statusCode) else {
      throw ServiceError.httpError(statusCode: http.statusCode)
    }
    
    // Decode snake_case JSON into your camelCase DTO
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(ChatCompletionResponse.self, from: data)
    } catch {
      throw ServiceError.decodingError(error)
    }
  }
}
