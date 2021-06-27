//
//  NetworkService.swift
//  BitcoinManager
//
//  Created by MihailsKuznecovs on 23/06/2021.
//

import Foundation

class NetworkService {
    enum RequestType: String {
        case get = "GET"
    }
    private var session: URLSession = .shared
    
    func makeRequest(toEndpoint endpoint: Endpoint.Type, fromURLString urlString: String? = nil, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        guard let url = prepareUrl(from: urlString, endpoint: endpoint) else {
            completion(.failure(.badURL))
            return
        }
        
        let request = createRequest(type: .get, url: url)
        let task = createDataTask(from: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            guard httpResponse.statusCode < 500 else {
                completion(.failure(.serverErrorCode))
                return
            }
            
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
    private func prepareUrl(from urlString: String?, endpoint: Endpoint.Type) -> URL? {
        var bodyComponents = URLComponents()
        if let urlString = urlString, urlString.contains("https://api.rss2json.com/v1/api.json") {
            return URL(string: urlString)
        } else {
            bodyComponents.scheme = endpoint.scheme
            bodyComponents.host = endpoint.host
            bodyComponents.path = endpoint.path
            
            if endpoint == RssConverterEndpoint.self {
                let queryItem = URLQueryItem(name: "rss_url", value: urlString)
                bodyComponents.queryItems = [queryItem]
            }
            
            return bodyComponents.url
        }
    }
    
    
    private func createRequest(type: RequestType, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }
    }
}
