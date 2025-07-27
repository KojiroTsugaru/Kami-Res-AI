//
//  GenerateDTO.swift
//  kami-res-ai
//
//  Created by kj on 7/27/25.
//

import Foundation

// MARK: - Root
struct ChatCompletionResponse: Codable {
  let status: String
  let data: ChatData
  let code: Int
}

// MARK: - Data
struct ChatData: Codable {
  let id: String
  let object: String
  let created: Int
  let model: String
  let choices: [Choice]
  let usage: Usage
  let serviceTier: String
  let systemFingerprint: String
}

// MARK: - Choice
struct Choice: Codable {
  let index: Int
  let message: Message
  let logprobs: JSONNull?
  let finishReason: String
}

// MARK: - Message
struct Message: Codable {
  let role: String
  let content: String
  let refusal: JSONNull?
  let annotations: [Annotation]
}

// MARK: - Annotation
struct Annotation: Codable { }

// MARK: - Usage
struct Usage: Codable {
  let promptTokens: Int
  let completionTokens: Int
  let totalTokens: Int
  let promptTokensDetails: PromptTokensDetails
  let completionTokensDetails: CompletionTokensDetails
}

// MARK: - PromptTokensDetails
struct PromptTokensDetails: Codable {
  let cachedTokens: Int
  let audioTokens: Int
}

// MARK: - CompletionTokensDetails
struct CompletionTokensDetails: Codable {
  let reasoningTokens: Int
  let audioTokens: Int
  let acceptedPredictionTokens: Int
  let rejectedPredictionTokens: Int
}

// MARK: - JSONNull
final class JSONNull: Codable, Hashable {
  public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool { true }
  public func hash(into hasher: inout Hasher) { }
  
  public init() { }
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    guard container.decodeNil() else {
      throw DecodingError.typeMismatch(
        JSONNull.self,
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Expected null value."
        )
      )
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encodeNil()
  }
}


