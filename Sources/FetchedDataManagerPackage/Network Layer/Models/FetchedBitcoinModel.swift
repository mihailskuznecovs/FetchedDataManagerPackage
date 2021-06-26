//
//  BitcoinModel.swift
//  BitcoinManager
//
//  Created by MihailsKuznecovs on 23/06/2021.
//

import Foundation

struct FetchedBitcoinModel: Decodable {
    let disclaimer: String
    let bpi: BPI
    let time: Time
}

struct BPI: Decodable {
    let EUR: EUR
}

struct Time: Decodable {
    let updatedISO: String
}

struct EUR: Decodable {
    let description: String
    let rate: String
    let rateFloat: Float
}
