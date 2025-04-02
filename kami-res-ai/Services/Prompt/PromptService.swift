import Foundation

// MARK: - エラー定義

enum PromptError: Error {
    case invalidURL
    case encodingError
    case decodingError
}

// MARK: - PromptService

class PromptService {
    static let shared = PromptService()
    
    private init() {} // Singleton: 外部からのインスタンス生成を防ぐ

    /// `POST`リクエストを送信して、promptを取得する
    func sendPromptRequest(length: Double, mood: String) async throws -> PromptSuccessResponse {
        guard let url = URL(string: Constants.Endpoint.prompt) else {
            throw PromptError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // DTOを作成し、JSONエンコードする
        let promptRequest = PromptRequestDTO(mood: mood, length: length)
        do {
            request.httpBody = try JSONEncoder().encode(promptRequest)
        } catch {
            throw PromptError.encodingError
        }
        
        // リクエスト送信
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // レスポンスをDTOにデコード
        do {
            let decodedResponse = try JSONDecoder().decode(PromptSuccessResponse.self, from: data)
            return decodedResponse
        } catch {
            throw PromptError.decodingError
        }
    }
}
