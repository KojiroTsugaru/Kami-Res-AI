import Foundation

// MARK: - DTO定義

/// リクエスト用DTO（moodとlengthのみ送信）
struct PromptRequestDTO: Codable {
    let mood: String
    let length: Double
}

/// process_parametersの戻り値用DTO
struct PromptResponseData: Codable {
    let prompt: String
}

/// 成功レスポンス用DTO
struct PromptSuccessResponse: Codable {
    let status: String    // "success" が返ることを想定
    let data: PromptResponseData
    let code: Int
}

