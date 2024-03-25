//
//  Sprites.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 25.03.2024.
//

import Foundation

struct Sprites: Codable {
    let defaultImage : String?
    let versions: Versions?

    enum CodingKeys: String, CodingKey {
        case defaultImage = "front_default"
        case versions
    }
}

struct Versions: Codable {
    let generationI: GenerationI?
    let generationIi: GenerationIi?

    enum CodingKeys: String, CodingKey {
        case generationI = "generation-i"
        case generationIi = "generation-ii"
    }
}

struct GenerationI: Codable {
    let redBlue, yellow: RedBlue?

    enum CodingKeys: String, CodingKey {
        case redBlue = "red-blue"
        case yellow
    }

    struct RedBlue: Codable {
        let frontDefault: String?

        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
}

struct GenerationIi: Codable {
    let crystal, gold, silver: Crystal?

    struct Crystal: Codable {
        let frontDefault: String?

        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
}
