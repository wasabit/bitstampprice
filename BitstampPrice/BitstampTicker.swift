//
//  Ticker.swift
//  Bitstamp Price
//
//  Created by Sebas on 08/12/17.
//  Copyright © 2017 WasabitLabs. All rights reserved.
//

import Foundation

struct BitstampTicker: Codable {
    let high: String
    let last: String
    let timestamp: String
    let bid: String
    let vwap: String
    let volume: String
    let low: String
    let ask: String
    let open: String
    let side: String?
    let open_24: String?
    let percent_change_24: String?
    let market_type: String?
    
    // Computed properties for easier access to numeric values
    var lastPrice: Double? {
        return Double(last)
    }
    
    var highPrice: Double? {
        return Double(high)
    }
    
    var lowPrice: Double? {
        return Double(low)
    }
    
    var bidPrice: Double? {
        return Double(bid)
    }
    
    var askPrice: Double? {
        return Double(ask)
    }
}
