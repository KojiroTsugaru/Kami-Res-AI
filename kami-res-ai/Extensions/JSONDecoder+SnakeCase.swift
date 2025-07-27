//
//  JSONDecoder+SnakeCase.swift
//  kami-res-ai
//
//  Created by kj on 7/27/25.
//

import Foundation

extension JSONDecoder {
  static let snakeCase: JSONDecoder = {
    let d = JSONDecoder()
    d.keyDecodingStrategy = .convertFromSnakeCase
    return d
  }()
}
