//
//  PokemonViewModel.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 03/10/2023.
//

import UIKit
import Combine

protocol PokemonViewModelType {
    var pageTitle: String { get }
    var pokemonsList: [Pokemon] { get }

    func transform(input: AnyPublisher<PokemonViewModel.InputEvent, Never>) -> AnyPublisher<PokemonViewModel.OutputEvent, Never>

    func fetchPokemons(_ nextPage: String?)

    func searchPokemons(_ term: String)
}

class PokemonViewModel: ObservableObject {
    enum InputEvent {
        case viewDidAppear
        case refreshListFired
        case loadMore(lastScrollPosition: Int)
        case searchFired(term: String)

        static func == (lhs: InputEvent, rhs: InputEvent) -> Bool {
            switch (lhs, rhs) {
            case (.viewDidAppear, .viewDidAppear): return true
            case (.refreshListFired, .refreshListFired): return true
            case (.loadMore, .loadMore): return true
            case (.searchFired, .searchFired): return true
            default: return false
            }
        }
    }

    enum OutputEvent: Equatable {
        case fetchListDidFail(error: Error)
        case fetchListDidSucceed(pokemons: [Pokemon])
        case showEmpty
        case showLoadingView(showLoading: Bool)
        case showLoadingMoreView(showLoading: Bool)
        case searchResults(pokemons: [Pokemon])
        case showEmptySearchResults

        static func == (lhs: OutputEvent, rhs: OutputEvent) -> Bool {
            switch (lhs, rhs) {
            case (.fetchListDidFail, .fetchListDidFail): return true
            case (.fetchListDidSucceed, .fetchListDidSucceed): return true
            case (.showEmpty, .showEmpty): return true
            case (.showLoadingView, .showLoadingView): return true
            case (.showLoadingMoreView, .showLoadingMoreView): return true
            case (.searchResults, .searchResults): return true
            case (.showEmptySearchResults, .showEmptySearchResults): return true
            default: return false
            }
        }
    }

    internal let outputEvents: PassthroughSubject<OutputEvent, Never> = .init()
    internal var cancellables = Set<AnyCancellable>()

    internal let pokemonRepository: PokemonRepositoryType
    // For offline use
    internal let pokemonCacheRepository: PokemonListResponseStorageType
    internal var nextPage: String?
    internal var pokemons: [Pokemon]?
    internal var lastScrollPosition: Int = 0
    internal var filteredPokemons: [Pokemon] = []

    init(
        pokemonRepository: PokemonRepositoryType? = DIContainer.shared
        .inject(type: PokemonRepositoryType.self),
        pokemonCacheRepository: PokemonListResponseStorageType? = DIContainer.shared
        .inject(type: PokemonListResponseStorageType.self)
    ) throws {
        guard let pokemonRepository = pokemonRepository,
              let pokemonCacheRepository = pokemonCacheRepository else {
            throw DIError.serviceNotFound
        }
        self.pokemonRepository = pokemonRepository
        self.pokemonCacheRepository = pokemonCacheRepository
    }
}
