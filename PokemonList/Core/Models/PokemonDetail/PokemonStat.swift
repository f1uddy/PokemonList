//
//  PokemonStat.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation

struct PokemonStat: Codable {
    let effort: Int
    let statValue: Int
    let stat: Stat?

    struct Stat: Codable {
        let name: String
        let url: String
    }

    enum CodingKeys: String, CodingKey {
        case effort
        case stat
        case statValue = "base_stat"
    }
}
