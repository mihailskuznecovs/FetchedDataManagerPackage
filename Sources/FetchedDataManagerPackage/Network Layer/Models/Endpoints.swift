//
//  Endpoints.swift
//  FetchedDataManager
//
//  Created by MihailsKuznecovs on 23/06/2021.
//

import Foundation

protocol Endpoint {
    static var scheme: String { get set }
    static var host: String { get set }
    static var path: String { get set }
}

struct CoinDeskEndpoint: Endpoint  {
    static var scheme = "https"
    static var host = "api.coindesk.com"
    static var path = "/v1/bpi/currentprice.json"
}

struct RssConverterEndpoint: Endpoint {
    static var scheme = "https"
    static var host = "api.rss2json.com"
    static var path = "/v1/api.json"
}
