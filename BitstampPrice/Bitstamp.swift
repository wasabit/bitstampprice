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
  
  private var formatedPrice: NSAttributedString {
    let attributes = [
      .foregroundColor: foreColor,
      .font: font,
      .backgroundColor: backgroundColor
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
    let formatter = NumberFormatter()
    let priceValue = NSNumber(value: lastPrice)
    
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    
    if let formattedTipAmount = formatter.string(from: priceValue) {
      return "$\(formattedTipAmount)"
    } else {
      return "No price"
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
}
