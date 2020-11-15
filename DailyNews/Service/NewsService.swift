//
//  NewsService.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-09.
//

import Foundation

struct NewsService {

  static var shared = NewsService()
  private let baseUrl = "https://newsapi.org/v2/"
  private let region = Locale.current.regionCode ?? "us"
  private var key: NSDictionary!

  private init() {
    if let keyFile = Bundle.main.path(forResource: "Key", ofType: "plist") {
      key = NSDictionary(contentsOfFile: keyFile)
    } else {
      fatalError("Needs API key in order to fetch news from API.")
    }
  }

  // MARK: - API methods

  func fetchTopHeadlines(completion: @escaping(Result<[Article], Error>) -> Void) {
    let urlString = baseUrl + "top-headlines?apiKey=\(key["apiKey"]!)&country=\(region)"

    guard let url = URL(string: urlString) else {
      completion(.failure(NSError(domain: "bad url", code: 0, userInfo: [:])))
      return
    }

    performRequest(url: url) { result in
      switch result {
      case .success(let apiResponse):
        completion(.success(apiResponse.articles ?? []))
      case .failure(let error):
        completion(.failure(NSError(domain: error.localizedDescription, code: 0, userInfo: [:])))
      }
    }
  }

  func search(for searchString: String, completion: @escaping(Result<[Article], Error>) -> Void) {
    let urlString = baseUrl + "everything?q=\(searchString)&apiKey=\(key["apiKey"]!)"

    guard let url = URL(string: urlString) else {
      completion(.failure(NSError(domain: "bad url", code: 0, userInfo: [:])))
      return
    }

    performRequest(url: url) { result in
      switch result {
      case .success(let apiResponse):
        completion(.success(apiResponse.articles ?? []))
      case .failure(let error):
        completion(.failure(NSError(domain: error.localizedDescription, code: 0, userInfo: [:])))
      }
    }
  }

  func fetchSources(completion: @escaping(Result<[Source], Error>) -> Void) {
    let urlString = baseUrl + "sources?apiKey=\(key["apiKey"]!)"

    guard let url = URL(string: urlString) else {
      completion(.failure(NSError(domain: "bad url", code: 0, userInfo: [:])))
      return
    }

    performRequest(url: url) { result in
      switch result {
      case .success(let apiResponse):
        completion(.success(apiResponse.sources ?? []))
      case .failure(let error):
        completion(.failure(NSError(domain: error.localizedDescription, code: 0, userInfo: [:])))
      }
    }
  }

  // MARK: - Private helper methods

  private func performRequest(url: URL, completion: @escaping(Result<ApiResponse, Error>) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(NSError(domain: error.localizedDescription, code: 0, userInfo: [:])))
        return
      }

      if let response = response as? HTTPURLResponse, response.statusCode != 200 {
          completion(.failure(NSError(domain: "HTTP Status", code: response.statusCode, userInfo: [:])))
          return
      }

      guard let data = data else {
        completion(.failure(NSError(domain: "Error with data", code: 0, userInfo: [:])))
        return
      }

      do {
        let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
        if apiResponse.status == "ok" {
          completion(.success(apiResponse))
        } else {
          completion(.failure(NSError(domain: apiResponse.message ?? "Unknown error from API", code: 0, userInfo: [:])))
        }
      } catch {
        completion(.failure(NSError(domain: "Failed to decode JSON data", code: 0, userInfo: [:])))
      }
    }.resume()
  }
}
