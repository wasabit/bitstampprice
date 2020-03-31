//
//  TickerTest.swift
//  Bitstamp PriceTests
//
//  Created by Sebas on 08/12/17.
//  Copyright © 2017 WasabitLabs. All rights reserved.
//

import XCTest

@testable import Bitstamp_Price

class BitstampTickerTest: XCTestCase {
  func testDecode() {
    let jsonString = """
      {
        "high": "16666.66",
        "last": "15198.96",
        "timestamp": "1512763757",
        "bid": "15142.76",
        "vwap": "15353.21",
        "volume": "26853.60919548",
        "low": "13482.42",
        "ask": "15177.98",
        "open": 16599.99
      }
      """
    
    let decoder = JSONDecoder()
    let data = jsonString.data(using: .utf8)!
    
    let ticker = try? decoder.decode(BitstampTicker.self, from: data)
    
    XCTAssertEqual("15198.96", ticker?.last)
  }
}
