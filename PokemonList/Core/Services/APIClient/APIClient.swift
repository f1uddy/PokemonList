//
//  APIClient.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation
import Combine

class APIClient<EndpointType: Endpoint>: APIClientInterface {

    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error> {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        endpoint.headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw ServiceError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

