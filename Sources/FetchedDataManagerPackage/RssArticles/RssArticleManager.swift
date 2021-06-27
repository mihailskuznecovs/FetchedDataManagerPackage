//
//  RssManager.swift
//  FetchedDataManager
//
//  Created by MihailsKuznecovs on 23/06/2021.
//

import Foundation

public class RssArticleManager {
    private let network = NetworkManager()
    
    public init() {}
    
    public func parseArticles(from urlString: String, completion: @escaping (Result<[ArticleModel], NetworkError>) -> Void) {
        network.parseArticles(from: urlString, completion: completion)
    }
}
