//
//  APIClient.swift
//  LayerDivisionUsingCombine
//
//  Created by 古賀貴伍社用 on 2023/08/30.
//

import Foundation
import Combine

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(endpoint: EndpointType) -> AnyPublisher<T, Error>
}

class URLSessionAPIClinet<EndpointType: APIEndpoint>: APIClient {
    func request<T: Decodable>(endpoint: EndpointType) -> AnyPublisher<T, Error> where T : Decodable {
        
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers?.forEach{ request.addValue($0.value, forHTTPHeaderField: $0.key)}
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, respons -> Data in
                guard let httpRespons = respons as? HTTPURLResponse,
                      (200...299).contains(httpRespons.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
