//
//  NewsService.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-09.
//

import Foundation

struct ApiResponse: Decodable {
  let status: String
  let code: String?
  let message: String?
  let articles: [Article]?
}

struct Article: Decodable, Hashable {
  let title: String
  let description: String?
  let url: String
  let urlToImage: String?
}

struct NewsService {

  static var shared = NewsService()

  let region = Locale.current.regionCode ?? "us"

  private var key: NSDictionary!

  private init() {
    if let keyFile = Bundle.main.path(forResource: "Key", ofType: "plist") {
      key = NSDictionary(contentsOfFile: keyFile)
    } else {
      fatalError("Needs API key in order to fetch news from API.")
    }
  }

  // TODO: remove this
  // temporary method fetching local json in order to keep API requests to a minimum
  // while developing as to not exhaust the 100 request per day limit
  func fetchTopHeadlinesLocal(completion: @escaping(Result<[Article], Error>) -> Void) {
    if let jsonUrl = Bundle.main.url(forResource: "us", withExtension: "json") {
      do {
        let json = try String(contentsOf: jsonUrl)
        let data = json.data(using: .utf8)!

        do {
          let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
          if apiResponse.status == "ok" {
            completion(.success(apiResponse.articles ?? []))

          }
        } catch {
          completion(.failure(NSError(domain: "Failed to decode local json", code: 0, userInfo: [:])))
        }
      } catch {
        print(error)
      }
    }
  }

  func fetchTopHeadlines(completion: @escaping(Result<[Article], Error>) -> Void) {
    let baseUrlString = "https://newsapi.org/v2/top-headlines?apiKey=\(key["apiKey"]!)&country=\(region)"

    guard let url = URL(string: baseUrlString) else {
      completion(.failure(NSError(domain: "bad url", code: 0, userInfo: [:])))
      return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(NSError(domain: error.localizedDescription, code: 0, userInfo: [:])))
        return
      }

      if let response = response as? HTTPURLResponse {
        guard response.statusCode == 200 else {
          completion(.failure(NSError(domain: "HTTP Status", code: response.statusCode, userInfo: [:])))
          return
        }
      }

      guard let data = data else {
        completion(.failure(NSError(domain: "Error with data", code: 0, userInfo: [:])))
        return
      }

      do {
        let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
        if apiResponse.status == "ok" {
          completion(.success(apiResponse.articles ?? []))
        } else {
          completion(.failure(NSError(domain: apiResponse.message!, code: 0, userInfo: [:])))
        }
      } catch {
        completion(.failure(NSError(domain: "Failed to decode JSON data", code: 0, userInfo: [:])))
      }
    }.resume()
  }

  func search(for searchString: String, completion: @escaping(Result<[Article], Error>) -> Void) {
    let baseUrlString = "https://newsapi.org/v2/everything?q=\(searchString)&apiKey=\(key["apiKey"]!)"

    print(baseUrlString)
    
    guard let url = URL(string: baseUrlString) else {
      completion(.failure(NSError(domain: "bad url", code: 0, userInfo: [:])))
      return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(NSError(domain: error.localizedDescription, code: 0, userInfo: [:])))
        return
      }
      if let response = response as? HTTPURLResponse {
        guard response.statusCode == 200 else {
          completion(.failure(NSError(domain: "HTTP Status", code: response.statusCode, userInfo: [:])))
          return
        }
      }

      guard let data = data else {
        completion(.failure(NSError(domain: "Error with data", code: 0, userInfo: [:])))
        return
      }

      do {
        let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
        if apiResponse.status == "ok" {
          completion(.success(apiResponse.articles ?? []))
        } else {
          completion(.failure(NSError(domain: apiResponse.message!, code: 0, userInfo: [:])))
        }
      } catch {
        completion(.failure(NSError(domain: "Failed to decode JSON data", code: 0, userInfo: [:])))
      }
    }.resume()
  }
}
