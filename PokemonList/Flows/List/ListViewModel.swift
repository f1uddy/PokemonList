//
//  ListViewModel.swift
//  PokemonList
//
//  Created by Kirill Verkhoturov on 21.03.2024.
//

import Foundation
import Combine

final class ListViewModel: ObservableObject {

    struct Input {
        let refresh: PassthroughSubject<Void, Never>
        let loadData: PassthroughSubject<Void, Never>
        let itemSelected: PassthroughSubject<PokemonItem, Never>
    }

    struct Output {
        let results: CurrentValueSubject<[PokemonItem], Error>
    }

    enum State {
        case loading
        case finished
        case error(Error)
    }

    enum Section { case pokemons }

    // MARK: - Properties

    let input: Input
    let output: Output

    @Published private(set) var pokemons: [PokemonItem] = []
    @Published private(set) var state: State = .loading

    private let onAppearSubject = PassthroughSubject<Void, Never>()
    private let resultSubject = CurrentValueSubject<[PokemonItem], Error>([])
    private let selectSubject = PassthroughSubject<PokemonItem, Never>()
    private var cancellables = Set<AnyCancellable>()

    private let router: ListRouter
    private let service: ListServiceInterface

    // MARK: - Init

    init(router: ListRouter,
         service: ListServiceInterface) {
        self.router = router
        self.service = service
        self.output = Output(results: resultSubject)
        self.input = Input(refresh: onAppearSubject,
                           loadData: onAppearSubject,
                           itemSelected: selectSubject)

        setupInput()
    }

    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    private func setupInput() {
        onAppearSubject
            .sink { [weak self] _ in
                self?.getList()
            }
            .store(in: &cancellables)

        selectSubject
            .sink { [weak self] item in
                self?.router.showDetails(for: item)
            }.store(in: &cancellables)
    }

    private func getList() {
        state = .loading

        let receiveCompletion: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.state = .error(error)
            case .finished:
                self?.state = .finished
            }
        }

        let receiveValue: (PokemonList) -> Void = { [weak self] pokemons in
            self?.pokemons = pokemons.results
            self?.resultSubject.send(pokemons.results)
        }

        service
            .getList()
            .sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
            .store(in: &cancellables)
    }

}
