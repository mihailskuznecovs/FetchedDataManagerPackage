//
//  BitcoinModel.swift
//  FetchedDataManager
//
//  Created by MihailsKuznecovs on 23/06/2021.
//

import Foundation

public struct BitcoinModel {
    public let currency: String
    public let rate: String
    public let disclaimer: String
    public let timeDifference: DateComponents
    public let rateChange: Float
}
