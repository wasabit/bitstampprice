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

    // Use the system menu bar font to match other menu bar items
    private let font: NSFont = NSFont.menuBarFont(ofSize: 0) // Size 0 uses the default system size
    private var foreColor: NSColor = .controlTextColor

    private var formattedPrice: NSAttributedString {
        let attributes = [
            .foregroundColor: foreColor,
            .font: font,
            .baselineOffset: NSNumber(value: -1) // Better alignment with other menu bar items
        ] as [NSAttributedString.Key : Any]

        return NSAttributedString(string: localizedPrice,
                                  attributes: attributes)
    }

    private var lastPrice: Double = 0 {
        didSet {
            guard lastPrice != oldValue else { return }

            // Use appearance-aware colors with better contrast
            if oldValue > lastPrice {
                // Price decreased - use red with better contrast for both light and dark modes
                foreColor = NSColor(named: NSColor.Name("PriceDownColor")) ??
                           NSColor.systemRed.withSystemEffect(.deepPressed)
            } else {
                // Price increased - use green with better contrast for both light and dark modes
                foreColor = NSColor(named: NSColor.Name("PriceUpColor")) ??
                           NSColor.systemGreen.withSystemEffect(.deepPressed)
            }
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
