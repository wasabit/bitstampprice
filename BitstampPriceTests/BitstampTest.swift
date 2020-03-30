//
//  BitstampTest.swift
//  Bitstamp PriceTests
//
//  Created by Sebas on 08/12/17.
//  Copyright © 2017 WasabitLabs. All rights reserved.
//

import XCTest
@testable import Bitstamp_Price

class BitstampText: XCTestCase {
  var sut: Bitstamp!
  
  override func setUp() {
    super.setUp()
    
    self.sut = Bitstamp()
    sut.tickerFetcher = FakeFetcher()
  }
  
  func testShowPriceWhite() {
    sut.showPrice { _ in }
    sut.showPrice { (price) in
      XCTAssertEqual(NSColor.white, self.priceColor(price))
    }
  }
  
  func testShowPriceGreen() {
    sut.showPrice { (price) in
      XCTAssertEqual(NSColor.green, self.priceColor(price))
    }
  }
  
  func testShowPriceRed() {
    let tickerFetcher = sut.tickerFetcher as! FakeFetcher
    
    tickerFetcher.last = "-200"
    
    sut.showPrice { (price) in
      XCTAssertEqual(NSColor.red, self.priceColor(price))
    }
  }
  
  private func priceColor(_ price: NSAttributedString) -> NSColor {
    let color = price.attribute(NSAttributedString.Key.foregroundColor,
                                at: 1, effectiveRange: nil)
    
    return color as! NSColor
  }
}

class FakeFetcher: TickerFetcher {
  var last = "123"
  
  func fetch(block: @escaping (BitstampTicker?) -> ()) {
    let ticker = BitstampTicker(high: "123", last: last, timestamp: "123",
                                bid: "123", vwap: "123", volume: "123",
                                low: "123", ask: "123", open: 123)
    block(ticker)
  }
}
