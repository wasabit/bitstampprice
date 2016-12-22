//
//  TickerFetcher.swift
//  Bitstamp Price
//
//  Created by Sebas on 08/12/17.
//  Copyright © 2017 WasabitLabs. All rights reserved.
//

protocol TickerFetcher {
    func fetch(block: @escaping (BitstampTicker?) -> ())
}
