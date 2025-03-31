//
//  OpenAIService.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import Foundation

class OpenAIService {
    static let apiKey = Constants.AccessToken.openAI
    static let endpoint = Constants.Endpoint.openAI
    static let model = "gpt-4o"
    static let maxTokens: Int = 1000

    func getSuggestedReplyFromImage(imageData: Data, messageConfig: MessageConfiguration) async throws -> String {
        
        // MARK: Get prompt from api
        let prompt = await getPrompt(for: messageConfig)
        
        guard let prompt = prompt else { return "" }
        
        guard let url = URL(string: Self.endpoint) else {
            throw OpenAIServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(Self.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert image to Base64
        let base64Image = imageData.base64EncodedString()

        // JSON Payload (Valid for OpenAI API)
        let payload: [String: Any] = [
            "model": Self.model,
            "messages": [
                [
                    "role": "user",
                    "content": [
                        ["type": "text", "text": prompt],
                        ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(base64Image)"]]
                    ]
                ]
            ],
            "max_tokens": Self.maxTokens
        ]

        // Convert to JSON
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error)")
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
    
    func getSuggestedReply(recipientName: String, chatHistory: [ChatHistoryItem]) async throws -> String {
        guard let url = URL(string: Self.endpoint) else {
            throw OpenAIServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(Self.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // プロンプト作成
        let formattedChatHistory = formatChatHistory(chatHistory: chatHistory)
        let promptHelper =
            """
            #前提
            ・以下は\(recipientName)との過去の会話履歴です。\n
            """
         
        let prompt = ""
        let finalPrompt = promptHelper + prompt
        
        let payload: [String: Any] = [
            "model": Self.model,
            "messages": [
                ["role": "user", "content": formattedChatHistory],
                ["role": "system", "content": finalPrompt]
            ],
            "max_tokens": Self.maxTokens
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData
        } catch {
            throw OpenAIServiceError.encodingError
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw OpenAIServiceError.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            if let content = decodedResponse.choices.first?.message.content {
                return content
            } else {
                throw OpenAIServiceError.emptyResponse
            }
        } catch {
            throw OpenAIServiceError.decodingError
        }
    }
    
    private func formatChatHistory(chatHistory: [ChatHistoryItem]) -> String {
        var formattedHistory = ""
        
        for (_, item) in chatHistory.enumerated() {
            formattedHistory += "\"\(item.sender)\": \(item.message)\n"
        }
        
        return formattedHistory.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: Get prompt from api
    private func getPrompt(for config: MessageConfiguration) async -> String? {
        do {
            let response = try await PromptService.shared.sendPromptRequest(
                length: config.length.rawValue,
                mood: config.mood.rawValue
            )
            print("Prompt: \(response.prompt), Status: \(response.status)")
            return response.prompt
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}
