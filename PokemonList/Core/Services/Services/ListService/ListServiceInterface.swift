//
//  ListServiceInterface.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation
import Combine

typealias ListPublisher = AnyPublisher<PokemonList, Error>

protocol ListServiceInterface {
    func getList() -> ListPublisher
}

