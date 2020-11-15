//
//  ApiResponse.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-11.
//

import Foundation

struct ApiResponse: Decodable {
  let status: String
  let code: String?
  let message: String?
  let articles: [Article]?
  let sources: [Source]?
}
