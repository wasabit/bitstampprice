//
//  Ticker.swift
//  Bitstamp Price
//
//  Created by Sebas on 08/12/17.
//  Copyright © 2017 WasabitLabs. All rights reserved.
//

import Foundation

struct BitstampTicker: Codable {
  var high: String
  var last: String
  var timestamp: String
  var bid: String
  var vwap: String
  var volume: String
  var low: String
  var ask: String
  var open: Double
}
