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
    func testShowPriceWhite() {
        let sut = Bitstamp()
        sut.tickerFetcher = FakeFetcher()

        sut.showPrice { _ in }
        sut.showPrice { (price) in
            print(price)
            XCTAssertEqual(NSColor.white, price.attribute(NSAttributedStringKey.foregroundColor, at: 1, effectiveRange: nil) as! NSColor)
        }
    }

    func testShowPriceGreen() {
        let sut = Bitstamp()
        sut.tickerFetcher = FakeFetcher()

        sut.showPrice { (price) in
            print(price)
            XCTAssertEqual(NSColor.green, price.attribute(NSAttributedStringKey.foregroundColor, at: 1, effectiveRange: nil) as! NSColor)
        }
    }

    func testShowPriceRed() {
        let sut = Bitstamp()
        let tickerFetcher = FakeFetcher()
        sut.tickerFetcher = tickerFetcher

        tickerFetcher.last = "-200"

        sut.showPrice { (price) in
            print(price)
            XCTAssertEqual(NSColor.red, price.attribute(NSAttributedStringKey.foregroundColor, at: 1, effectiveRange: nil) as! NSColor)
        }
    }
}

class FakeFetcher: TickerFetcher {
    var last = "123"

    func fetch(block: @escaping (BitstampTicker?) -> ()) {
        block(BitstampTicker(high: "123", last: last, timestamp: "123", bid: "123", vwap: "123", volume: "123", low: "123", ask: "123", open: 123))
    }
}
