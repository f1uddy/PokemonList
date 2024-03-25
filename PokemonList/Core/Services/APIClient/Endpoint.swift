//
//  Endpoint.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

extension Endpoint {
    var headers: [String: String]? {
        return nil
    }

    var parameters: [String: Any]? {
        return nil
    }
}

enum ServiceError: Error {
    case url(Error)
    case invalidResponse
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
