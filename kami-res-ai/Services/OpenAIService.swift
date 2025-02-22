//
//  OpenAIService.swift
//  MoteAI
//
//  Created by KJ on 1/18/25.
//

import Foundation

class OpenAIService {
    private let apiKey = Constants.AccessToken.openAI
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    private let model = "gpt-4o"
    private let maxTokens: Int = 1000

    func getSuggestedReplyFromImage(base64Image: String, messageMood: MessageMood) async throws -> String {
        
        guard let url = URL(string: endpoint) else {
            throw OpenAIServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let meessageLengthText = messageLengthText(messageMood: messageMood)
        
        let promptHelper =
            """
            #前提
            ・この画像はあなたが仲良くなりたい思っている相手とのチャットのスクリーンショットです。
            
            #守らなければいけない制約
            ・日本語で必ず回答すること。
            ・"「", "」"を使わないでください。
            ・\(meessageLengthText)文字以内で生成してください。\n
            """
         
        let finalPrompt = promptHelper + messageMood.type.prompt
        print(finalPrompt)
        
        // Create the JSON payload
        let payload: [String: Any] = [
            "model": model,
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": finalPrompt
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
    
    func getSuggestedReply(recipientName: String, chatHistory: [ChatHistoryItem], prompt: String) async throws -> String {
        guard let url = URL(string: endpoint) else {
            throw OpenAIServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // プロンプト作成
        let formattedChatHistory = formatChatHistory(chatHistory: chatHistory)
        let promptHelper =
            """
            #前提
            ・以下は\(recipientName)との過去の会話履歴です。\n
            """
         
        let finalPrompt = promptHelper + prompt
        
        let payload: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "user", "content": formattedChatHistory],
                ["role": "system", "content": finalPrompt]
            ],
            "max_tokens": maxTokens
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
    
    private func messageLengthText(messageMood: MessageMood) -> String {
        switch messageMood.messageLength {
        case .short:
            return "10"
        case .medium:
            return "20"
        case .long:
            return "30"
        }
    }
    
    private func formatChatHistory(chatHistory: [ChatHistoryItem]) -> String {
        var formattedHistory = ""
        
        for (_, item) in chatHistory.enumerated() {
            formattedHistory += "\"\(item.sender)\": \(item.message)\n"
        }
        
        return formattedHistory.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
