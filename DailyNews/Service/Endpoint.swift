//
//  Endpoint.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-25.
//

import Foundation

enum Endpoint {
  case headlines
  case search(query: String)
  case sources
  case headlinesFor(id: String)

  private var baseUrl: String {
   return "https://newsapi.org/v2/"
  }

  private var key: NSDictionary! {
    if let keyFile = Bundle.main.path(forResource: "Key", ofType: "plist") {
      return NSDictionary(contentsOfFile: keyFile)
    } else {
      fatalError("Needs API key in order to fetch news from API.")
    }
  }

  private var region: String {
    return Locale.current.regionCode ?? "us"
  }
}

extension Endpoint {
  var url: URL {
    switch self {
    case .headlines:
      return URL(string: baseUrl + "top-headlines?apiKey=\(key["apiKey"]!)&country=\(region)")!
    case .search(let query):
      return URL(string: baseUrl + "everything?q=\(query)&apiKey=\(key["apiKey"]!)")!
    case .sources:
      return URL(string: baseUrl + "sources?apiKey=\(key["apiKey"]!)")!
    case .headlinesFor(let id):
      return URL(string: baseUrl + "top-headlines?apiKey=\(key["apiKey"]!)&sources=\(id)")!
    }
  }
}
