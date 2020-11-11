//
//  Article.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-11.
//

import Foundation

struct Article: Decodable, Hashable {
  let title: String
  let description: String?
  let url: String
  let urlToImage: String?
}
