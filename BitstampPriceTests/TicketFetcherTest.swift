//
//  TicketFetcherTest.swift
//  Bitstamp Price
//
//  Created by Sebas on 08/12/17.
//  Copyright © 2017 WasabitLabs. All rights reserved.
//

import XCTest
@testable import Bitstamp_Price

class BitstampTickerFetcherTest: XCTestCase {
    func testFetch() {
        let sut = BitstampFetcher()
        let expect = expectation(description: "Foo")

        sut.fetch { (ticker) in
            XCTAssertNotNil(ticker!.last)
            expect.fulfill()
        }

        wait(for: [expect], timeout: 1)
    }
}
