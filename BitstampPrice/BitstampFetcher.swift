//
//  Bitstamp.swift
//  Bitstamp Price
//
//  Created by Sebas on 08/12/17.
//  Copyright © 2017 WasabitLabs. All rights reserved.
//

import Foundation

class BitstampFetcher: TickerFetcher {
  func fetch(then completion: @escaping (BitstampTicker?) -> ()) {
    let url = URL(string: "https://www.bitstamp.net/api/ticker/")!

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      DispatchQueue.main.async {
        guard error == nil else { return }
        
        let decoder = JSONDecoder()
        let status = (response as! HTTPURLResponse).statusCode
        
        guard status == 200, let data = data else { return }
        
        let ticker = try? decoder.decode(BitstampTicker.self, from: data)
        
        completion(ticker)
      }
    }
    task.resume()
  }
}
