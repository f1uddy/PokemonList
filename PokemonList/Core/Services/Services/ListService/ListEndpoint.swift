//
//  ListEndpoint.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation

enum ListEndpoint: Endpoint {
    case getList

    var baseURL: URL {
        guard let url = URL(string: "https://pokeapi.co/api/v2") else {
            fatalError("Bad URL!")
        }
        return url
    }

    var path: String {
        switch self {
        case .getList:
            return "/pokemon"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getList:
            return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getList:
            return nil
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .getList:
            return nil
        }
    }
}
