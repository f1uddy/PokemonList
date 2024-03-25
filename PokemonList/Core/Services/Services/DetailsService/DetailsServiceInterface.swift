//
//  DetailsServiceInterface.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation
import Combine

typealias DetailsPublisher = AnyPublisher<Pokemon, Error>

protocol DetailsServiceInterface {
    func getDetails(with id: String) -> DetailsPublisher
}
