//
//  PokemonItemCellViewModel.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation
import Combine

final class PokemonItemCellViewModel {
    @Published var name: String = ""
    @Published var url: String = ""

    private let pokemon: PokemonItem

    init(pokemon: PokemonItem) {
        self.pokemon = pokemon

        setupBindings()
    }

    private func setupBindings() {
        name = pokemon.name

    }
}
