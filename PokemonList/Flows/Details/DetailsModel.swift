//
//  DetailsModel.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation

struct DetailsModel: Hashable {
    
    static func == (lhs: DetailsModel, rhs: DetailsModel) -> Bool {
        return lhs.pokemon.id == rhs.pokemon.id
    }
    
    let pokemon: Pokemon

    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}
