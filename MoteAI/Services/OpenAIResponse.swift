//
//  OpenAIResponse.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import Foundation

// MARK: - Models
struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let role: String
    let content: String
}

// MARK: - Errors
enum OpenAIServiceError: Error {
    case invalidURL
    case invalidResponse
    case encodingError
    case decodingError
    case emptyResponse
}
