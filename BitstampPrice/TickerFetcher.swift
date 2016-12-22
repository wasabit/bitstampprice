//
//  Bitstamp.swift
//  BitstampPrice
//
//  Created by Sebas on 08/12/17.
//  Copyright © 2017 WasabitLabs. All rights reserved.
//

import Foundation

class TickerFetcher {
    private let url = "https://www.bitstamp.net/api/ticker/"

    func fetch(block: @escaping (Ticker?) -> ()) {
        var request = URLRequest(url: URL(string: url)!)

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else { return }

                let decoder = JSONDecoder()
                let status = (response as! HTTPURLResponse).statusCode

                guard status == 200, let data = data else { return }

                let ticker = try? decoder.decode(Ticker.self, from: data)

                block(ticker)
            }
        }
        task.resume()
    }
}
