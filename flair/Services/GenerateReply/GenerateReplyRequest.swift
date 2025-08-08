//
//  GenerateReplyRequest.swift
//  flair
//
//  Created by kj on 7/27/25.
//

import Foundation

struct GenerateReplyRequest: Codable {
  let imageData: Data
  let mood: String
  let length: Double
  
  init(imageData: Data, mood: MessageMood = .casual, length: MessageLength = .medium) {
    self.imageData = imageData
    self.mood = mood.rawValue
    self.length = length.rawValue
  }
  
  init(imageData: Data, config: MessageConfiguration) {
    self.imageData = imageData
    self.mood = config.mood.rawValue
    self.length = config.length.rawValue
  }
}
