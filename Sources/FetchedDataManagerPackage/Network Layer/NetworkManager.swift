//
//  NetworkManager.swift
//  BitcoinManager
//
//  Created by MihailsKuznecovs on 23/06/2021.
//

import Foundation

class NetworkManager {
    private let network = NetworkService()
    
    func ParseBitcoin(completion: @escaping (FetchedBitcoinModel?) -> Void) {
        network.makeRequest(toEndpoint: CoinDeskEndpoint.self) { data in
            if let json = self.decodeJSON(type: FetchedBitcoinModel.self, from: data) {
                completion(json)
            } else {
                completion(nil)
            }
        }
    }
    
    func parseArticles(from urlString: String, completion: @escaping ([ArticleModel]) -> Void) {
        network.makeRequest(toEndpoint: RssConverterEndpoint.self, fromURLString: urlString) { data in
            if let json = self.decodeJSON(type: FetchedArticlesModel.self, from: data) {
                completion(json.items)
            } else {
                completion([])
            }
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = data, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
