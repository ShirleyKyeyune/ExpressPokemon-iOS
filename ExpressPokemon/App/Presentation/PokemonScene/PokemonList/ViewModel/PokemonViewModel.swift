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
    var isSearching: Bool { get set }
    var shouldFetchMoreItems: Bool { get }

    func transform(input: AnyPublisher<PokemonViewModel.InputEvent, Never>) -> AnyPublisher<PokemonViewModel.OutputEvent, Never>

    func fetchPokemons(_ nextPage: String?)

    func searchPokemons(_ term: String)
}

class PokemonViewModel: ObservableObject {
    enum InputEvent {
        case viewDidAppear
        case refreshListFired
        case loadMore
        case beginSearch
        case cancelSearch
        case searchFired(term: String)

        static func == (lhs: InputEvent, rhs: InputEvent) -> Bool {
            switch (lhs, rhs) {
            case (.viewDidAppear, .viewDidAppear): return true
            case (.refreshListFired, .refreshListFired): return true
            case (.loadMore, .loadMore): return true
            case (.searchFired, .searchFired): return true
            case (.beginSearch, .beginSearch): return true
            case (.cancelSearch, .cancelSearch): return true
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
        case addNewResults(newPokemons: [Pokemon])

        static func == (lhs: OutputEvent, rhs: OutputEvent) -> Bool {
            switch (lhs, rhs) {
            case (.fetchListDidFail, .fetchListDidFail): return true
            case (.fetchListDidSucceed, .fetchListDidSucceed): return true
            case (.showEmpty, .showEmpty): return true
            case (.showLoadingView, .showLoadingView): return true
            case (.showLoadingMoreView, .showLoadingMoreView): return true
            case (.searchResults, .searchResults): return true
            case (.showEmptySearchResults, .showEmptySearchResults): return true
            case (.addNewResults, .addNewResults): return true
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
    internal var filteredPokemons: [Pokemon] = []
    let maximumItemCount = 100
    var isFetchingMore = false
    var isSearching = false

    init?(
        pokemonRepository: PokemonRepositoryType? = injected(PokemonRepositoryType.self),
        pokemonCacheRepository: PokemonListResponseStorageType? = injected(PokemonListResponseStorageType.self)
    ) {
        guard let pokemonRepository = pokemonRepository,
              let pokemonCacheRepository = pokemonCacheRepository else {
            return nil
        }
        self.pokemonRepository = pokemonRepository
        self.pokemonCacheRepository = pokemonCacheRepository
    }
}
