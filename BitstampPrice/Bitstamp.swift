//
//  Bitstamp.swift
//  Bitstamp Price
//
//  Created by Sebas on 08/12/17.
//  Copyright © 2017 WasabitLabs. All rights reserved.
//

import Cocoa

class Bitstamp {
    lazy var tickerFetcher: TickerFetcher = BitstampFetcher()
    
    private let font: NSFont = .systemFont(ofSize: 15)
    private let backgroundColor: NSColor = .black
    private var foreColor: NSColor = .white
    
    private var formattedPrice: NSAttributedString {
        let attributes = [
            .foregroundColor: foreColor,
            .font: font,
            .backgroundColor: backgroundColor,
        ] as [NSAttributedString.Key : Any]
        
        return NSAttributedString(string: localizedPrice,
                                  attributes: attributes)
    }
    
    private var lastPrice: Double = 0 {
        didSet {
            guard lastPrice != oldValue else { return }
            
            foreColor = oldValue > lastPrice ? .red : .green
        }
    }
    
    private var localizedPrice: String {
        guard lastPrice > 0 else { return "No price" }
        
        let formatter = NumberFormatter()
        let priceValue = NSNumber(value: lastPrice)
        
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: priceValue) ?? "No price"
    }
    
    func showPrice(completion: @escaping (NSAttributedString) -> ()) {
        tickerFetcher.fetch { [weak self] ticker in
            guard let self = self else { return }
            
            if let ticker = ticker, let price = ticker.lastPrice {
                self.lastPrice = price
            } else {
                // Handle error case - keep the last known price or show error
                print("Failed to fetch price data")
            }
            
            completion(self.formattedPrice)
        }
    }
}
