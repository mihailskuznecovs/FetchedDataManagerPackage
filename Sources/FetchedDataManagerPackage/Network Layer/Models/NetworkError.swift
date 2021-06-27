//
//  File.swift
//  
//
//  Created by MihailsKuznecovs on 27/06/2021.
//

import Foundation

public enum NetworkError: String, Error {
    case badURL = "There was problem creating URL"
    case noResponse = "No response from the server"
    case serverErrorCode = "There was problem connecting to the server"
    case noData = "There is no Data Received"
    case failDecoding = "Fail Decoding JSON"
}
