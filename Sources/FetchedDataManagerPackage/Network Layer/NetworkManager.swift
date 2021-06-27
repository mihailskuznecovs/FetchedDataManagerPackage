//
//  NetworkManager.swift
//  BitcoinManager
//
//  Created by MihailsKuznecovs on 23/06/2021.
//

import Foundation

class NetworkManager {
    private let network = NetworkService()
    
    func ParseBitcoin(completion: @escaping (Result<FetchedBitcoinModel, NetworkError>) -> Void) {
        network.makeRequest(toEndpoint: CoinDeskEndpoint.self) { result in
            switch result {
            
            case .success(let data):
                if let json = self.decodeJSON(type: FetchedBitcoinModel.self, from: data) {
                    completion(.success(json))
                } else {
                    completion(.failure(.failDecoding))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    func parseArticles(from urlString: String, completion: @escaping (Result<[ArticleModel], NetworkError>) -> Void) {
        network.makeRequest(toEndpoint: RssConverterEndpoint.self, fromURLString: urlString) { result in
            switch result {
            
            case .success(let data):
                if let json = self.decodeJSON(type: FetchedArticlesModel.self, from: data) {
                    completion(.success(json.items))
                } else {
                    completion(.failure(.failDecoding))
                }
            case .failure(let error):
                completion(.failure(error))
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
