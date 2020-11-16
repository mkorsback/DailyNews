//
//  Source.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-15.
//

import Foundation

struct Source: Decodable, Hashable {
  let id: String
  let name: String
  let description: String
  let url: String
  let category: String
  let language: String
  let country: String
}
