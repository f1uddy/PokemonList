//
//  DetailsViewModel.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation
import Combine

final class DetailsViewModel: ObservableObject {

    enum Section {
        case info
        case stats
        case generation
    }

    enum State {
        case loading
        case finished
        case error(Error)
    }

    struct Input {
        let refresh: PassthroughSubject<Void, Never>
        let loadData: PassthroughSubject<Void, Never>
    }

    struct Output {
        let results: CurrentValueSubject<DetailsModel?, Error>
    }

    // MARK: - Properties

    let input: Input
    let output: Output

    private let service: DetailsServiceInterface
    private let listItem: PokemonItem

    @Published private(set) var pokemonModel: DetailsModel?
    @Published private(set) var state: State = .loading

    private let onAppearSubject = PassthroughSubject<Void, Never>()
    private let resultSubject = CurrentValueSubject<DetailsModel?, Error>(nil)
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(service: DetailsServiceInterface,
         listItem: PokemonItem) {
        self.service = service
        self.listItem = listItem
        self.output = Output(results: resultSubject)
        self.input = Input(refresh: onAppearSubject, loadData: onAppearSubject)

        setupInput()
    }

    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    private func setupInput() {
        onAppearSubject
            .sink { [weak self] _ in
                self?.getDetails()
            }
            .store(in: &cancellables)
    }

    private func getDetails() {
        state = .loading

        let receiveCompletion: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.state = .error(error)
            case .finished:
                self?.state = .finished
            }
        }

        let receiveValue: (Pokemon) -> Void = { [weak self] pokemon in
            self?.pokemonModel =  DetailsModel(pokemon: pokemon)
            self?.resultSubject.send(self?.pokemonModel)
        }

        service
            .getDetails(with: listItem.name)
            .sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
            .store(in: &cancellables)
    }
}
