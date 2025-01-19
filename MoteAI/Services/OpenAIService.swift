//
//  OpenAIService.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import Foundation

class OpenAIService {
    private let apiKey = AccessTokens.openai
    private let endpoint = "https://api.openai.com/v1/chat/completions"

    func getSuggestedMesssageFromImage(base64Image: String, model: String = "gpt-4o-mini", maxTokens: Int = 300) async throws -> String {
        
        let prompt = OpenAIPrompt.prompt
        
        guard let url = URL(string: endpoint) else {
            throw OpenAIServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request
            .setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the JSON payload
        let payload: [String: Any] = [
            "model": model,
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": prompt
                        ],
                        [
                            "type": "image_url",
                            "image_url": ["url": "data:image/jpeg;base64,\(base64Image)"]
                        ]
                    ]
                ]
            ],
            "max_tokens": maxTokens
        ]
        
        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: payload,
                options: []
            )
            request.httpBody = jsonData
        } catch {
            throw OpenAIServiceError.encodingError
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw OpenAIServiceError.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(
                OpenAIResponse.self,
                from: data
            )
            if let content = decodedResponse.choices.first?.message.content {
                return content
            } else {
                throw OpenAIServiceError.emptyResponse
            }
        } catch {
            throw OpenAIServiceError.decodingError
        }
    }
}
