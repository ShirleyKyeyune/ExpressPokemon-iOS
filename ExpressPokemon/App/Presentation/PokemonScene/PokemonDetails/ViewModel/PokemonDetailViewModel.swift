//
//  PokemonDetailViewModel.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import Combine

protocol PokemonDetailViewModelType {
    var pageTitle: String { get }
    var pokemonDetail: PokemonDetail? { get }
    var pokemon: Pokemon { get }
    var commaSeparatedTypes: String { get }
    var abilities: [String] { get }

    func transform(input: AnyPublisher<PokemonDetailViewModel.InputEvent, Never>) -> AnyPublisher<PokemonDetailViewModel.OutputEvent, Never>

    func fetchPokemonDetail(for id: Int)
}

class PokemonDetailViewModel: ObservableObject {
    enum InputEvent {
        case viewDidAppear
        case refreshDetailFired

        static func == (lhs: InputEvent, rhs: InputEvent) -> Bool {
            switch (lhs, rhs) {
            case (.viewDidAppear, .viewDidAppear): return true
            case (.refreshDetailFired, .refreshDetailFired): return true
            default: return false
            }
        }
    }

    enum OutputEvent: Equatable {
        case fetchDetailDidFail(error: Error)
        case fetchDetailDidSucceed(pokemonDetail: PokemonDetail)
        case showLoadingView(showLoading: Bool)

        static func == (lhs: OutputEvent, rhs: OutputEvent) -> Bool {
            switch (lhs, rhs) {
            case (.fetchDetailDidFail, .fetchDetailDidFail): return true
            case (.fetchDetailDidSucceed, .fetchDetailDidSucceed): return true
            case (.showLoadingView, .showLoadingView): return true
            default: return false
            }
        }
    }

    internal let outputEvents: PassthroughSubject<OutputEvent, Never> = .init()
    internal var cancellables = Set<AnyCancellable>()

    internal let pokemonRepository: PokemonRepositoryType?
    internal var pokemonDetail: PokemonDetail?
    internal let pokemon: Pokemon

    init?(
        pokemon: Pokemon,
        pokemonRepository: PokemonRepositoryType? = injected(PokemonRepositoryType.self)
    ) {
        guard let pokemonRepository = pokemonRepository else {
            return nil
        }
        self.pokemon = pokemon
        self.pokemonRepository = pokemonRepository
    }
}
