//
//  Bitstamp.swift
//  Bitstamp Price
//
//  Created by Sebas on 08/12/17.
//  Copyright © 2017 WasabitLabs. All rights reserved.
//

import Foundation

class BitstampFetcher: TickerFetcher {
    private let session = URLSession.shared
    
    func fetch(then completion: @escaping (BitstampTicker?) -> ()) {
        // Modern approach with proper URL validation
        guard let url = URL(string: "https://www.bitstamp.net/api/v2/ticker/btcusd/") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                // Better error handling
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response type")
                    completion(nil)
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    print("HTTP error: \(httpResponse.statusCode)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    completion(nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let ticker = try decoder.decode(BitstampTicker.self, from: data)
                    completion(ticker)
                } catch {
                    print("Decoding error: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}
