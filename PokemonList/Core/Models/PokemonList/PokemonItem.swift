//
//  PokemonItem.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation

struct PokemonItem: Codable, Hashable {
    let name: String
    let url: URL
}
