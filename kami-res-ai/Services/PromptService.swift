import Foundation

public struct Endpoint {
    private static let baseUrl = "https://kami-res-ai-backend-production.up.railway.app/api/v1"
    public static let prompt = "\(baseUrl)/prompt"
}

// Define the response model
struct PromptResponse: Codable {
    let prompt: String
    let status: String
}

class PromptService {
    static let shared = PromptService()
    
    private init() {} // Singleton: Prevent external instantiation

    /// `POST` request to fetch a prompt
    func sendPromptRequest(length: Double, mood: String) async throws -> PromptResponse {
        guard let url = URL(string: Endpoint.prompt) else {
            throw PromptError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "mood": mood,
            "length": length
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            throw PromptError.encodingError
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let decodedResponse = try JSONDecoder().decode(PromptResponse.self, from: data)
            return decodedResponse
        } catch {
            throw PromptError.decodingError
        }
    }
}

// Define possible errors
enum PromptError: Error {
    case invalidURL
    case encodingError
    case decodingError
}
