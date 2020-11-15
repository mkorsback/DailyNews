//
//  Source.swift
//  DailyNews
//
//  Created by Mathias Korsbäck on 2020-11-15.
//

import Foundation

struct Source: Decodable, Hashable {
  let name: String
  let description: String
  let category: String
}
