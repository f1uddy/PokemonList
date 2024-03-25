//
//  PokemonDetail.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation

struct Pokemon: Codable {
    let id: Int
    let name: String
    let imageString: String?
    let stats: [PokemonStat]?
    let sprites : Sprites?

    struct Sprites: Codable {
        let defaultImage : String?
        let versions: Versions?

        enum CodingKeys: String, CodingKey {
            case defaultImage = "front_default"
            case versions
        }
    }

}

extension Pokemon: Hashable {

    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id
    }

}
