//
//  NewsService.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-09.
//

import Foundation

struct NewsService {

  static var shared = NewsService()

  private init() {}

  // MARK: - API methods

  func fetchTopHeadlines(completion: @escaping(Result<[Article], Error>) -> Void) {
    performRequest(endpoint: .headlines) { result in
      switch result {
      case .success(let apiResponse):
        completion(.success(apiResponse.articles ?? []))
      case .failure(let error):
        completion(.failure(NSError(domain: error.localizedDescription, code: 0, userInfo: [:])))
      }
    }
  }

  func search(for searchString: String, completion: @escaping(Result<[Article], Error>) -> Void) {
    let query = searchString.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    performRequest(endpoint: .search(query: query)) { result in
      switch result {
      case .success(let apiResponse):
        completion(.success(apiResponse.articles ?? []))
      case .failure(let error):
        completion(.failure(NSError(domain: error.localizedDescription, code: 0, userInfo: [:])))
      }
    }
  }

  func fetchSources(completion: @escaping(Result<[Source], Error>) -> Void) {
    performRequest(endpoint: .sources) { result in
      switch result {
      case .success(let apiResponse):
        completion(.success(apiResponse.sources ?? []))
      case .failure(let error):
        completion(.failure(NSError(domain: error.localizedDescription, code: 0, userInfo: [:])))
      }
    }
  }

  func fetchTopHeadlines(for id: String, completion: @escaping(Result<[Article], Error>) -> Void) {
    performRequest(endpoint: .headlinesFor(id: id)) { result in
      switch result {
      case .success(let apiResponse):
        completion(.success(apiResponse.articles ?? []))
      case .failure(let error):
        completion(.failure(NSError(domain: error.localizedDescription, code: 0, userInfo: [:])))
      }
    }
  }

  // MARK: - Private helper methods

  private func performRequest(endpoint: Endpoint, completion: @escaping(Result<ApiResponse, Error>) -> Void) {
    URLSession.shared.dataTask(with: endpoint.url) { data, response, error in
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
