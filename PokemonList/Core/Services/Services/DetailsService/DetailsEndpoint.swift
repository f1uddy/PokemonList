//
//  DetailsEndpoint.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation

enum DetailsEndpoint: Endpoint {
    case getDetails(id: String)

    var baseURL: URL {
        guard let url = URL(string: "https://pokeapi.co/api/v2") else {
            fatalError("Bad URL!")
        }
        return url
    }

    var path: String {
        switch self {
        case .getDetails(let id):
            return "/pokemon/" + id
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getDetails:
            return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getDetails:
            return nil
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .getDetails:
            return nil
        }
    }
}

