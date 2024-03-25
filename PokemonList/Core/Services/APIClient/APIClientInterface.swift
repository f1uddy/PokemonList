//
//  APIClientInterface.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation
import Combine

protocol APIClientInterface {
    associatedtype EndpointType: Endpoint

    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error>

}
