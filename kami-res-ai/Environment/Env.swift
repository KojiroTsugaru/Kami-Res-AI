//
//  Environment.swift
//  kami-res-ai
//
//  Created by kj on 7/28/25.
//

import Foundation

enum Env {
  static var apiBaseURL: URL {
    guard let host = Bundle.main.object(forInfoDictionaryKey: "API_HOST") as? String,
          let version = Bundle.main.object(forInfoDictionaryKey: "API_VERSION") as? String,
          let url = URL(string: "https://\(host)/\(version)")
    else {
      fatalError("‼️ API_HOST or API_VERSION is missing or invalid")
    }
    return url
  }
  
  static var superwallAccessToken: String {
    guard let token = Bundle.main
      .object(forInfoDictionaryKey: "SUPERWALL_ACCESS_TOKEN") as? String else {
      fatalError("‼️ SUPERWALL_ACCESS_TOKEN is missing or invalid")
    }
    return token
  }
}
