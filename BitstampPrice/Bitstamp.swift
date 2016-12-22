//
//  Bitstamp.swift
//  Bitstamp Price
//
//  Created by Sebas on 08/12/17.
//  Copyright © 2017 WasabitLabs. All rights reserved.
//

import Cocoa

class Bitstamp {
    var tickerFetcher: TickerFetcher = BitstampFetcher()

    private let font = NSFont.systemFont(ofSize: 15)
    private let backgroundColor = NSColor.black
    private var formatedPrice: NSAttributedString = NSAttributedString(string: "0.00")
    private var lastPrice: Double = 0 {
        didSet {
            let color = makeColor(lastPrice, oldValue)
            let attributes = [NSAttributedStringKey.foregroundColor: color,
                              NSAttributedStringKey.font: font,
                              NSAttributedStringKey.backgroundColor: backgroundColor] as [NSAttributedStringKey : Any]
            formatedPrice = NSAttributedString(string: localizedPrice, attributes: attributes)
        }
    }

    private var localizedPrice: String {
        let formatter = NumberFormatter()

        formatter.numberStyle = .decimal

        if let formattedTipAmount = formatter.string(from: lastPrice as NSNumber) {
            return "$\(formattedTipAmount)"
        } else {
            return "0.00"
        }
    }

    func showPrice(completion: @escaping (NSAttributedString) -> ()) {
        tickerFetcher.fetch { (ticker) in
            if let ticker = ticker {
                self.lastPrice = Double(ticker.last)!
            }
            completion(self.formatedPrice)
        }
    }

    private func makeColor(_ lastPrice: Double, _ oldValue: Double) -> NSColor {
        switch lastPrice {
        case _ where lastPrice < oldValue:
            return NSColor.red
        case _ where lastPrice > oldValue:
            return NSColor.green
        default:
            return NSColor.white
        }
    }
}
