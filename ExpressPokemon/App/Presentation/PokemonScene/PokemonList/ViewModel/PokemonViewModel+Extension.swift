//
//  PokemonViewModel+Extension.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import Combine
import Foundation

extension PokemonViewModel: PokemonViewModelType {
    var pageTitle: String {
        Constants.Title.mainTitle
    }

    var pokemonsList: [Pokemon] {
        guard let pokemons = pokemons else {
            return []
        }
        return pokemons
    }

    var shouldFetchMoreItems: Bool {
        !isFetchingMore && pokemonsList.count < maximumItemCount && !isSearching
    }

    func transform(input: AnyPublisher<InputEvent, Never>) -> AnyPublisher<OutputEvent, Never> {
        input.sink { [weak self] event in
            guard let `self` = self else {
                return
            }
            switch event {
            case .viewDidAppear:
                if pokemons == nil {
                    self.fetchPokemons()
                }

            case .refreshListFired:
                pokemons?.removeAll()
                self.fetchPokemons()

            case .loadMore:
                self.isFetchingMore = true
                self.fetchPokemons(self.nextPage)

            case .searchFired(let term):
                self.isSearching = true
                self.searchPokemons(term)

            case .beginSearch:
                self.isSearching = true

            case .cancelSearch:
                self.isSearching = false
                outputEvents.send(.searchResults(pokemons: pokemonsList))
            }
        }
        .store(in: &cancellables)
        return outputEvents.eraseToAnyPublisher()
    }

    func fetchPokemons(_ nextPage: String? = nil) {
        let event: OutputEvent = nextPage == nil
        ? .showLoadingView(showLoading: true)
        : .showLoadingMoreView(showLoading: true)

        outputEvents.send(event)

        pokemonRepository.fetchPage(nextPageUrl: nextPage)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    // use cached data
                    if let pokemonList = self?.fetchAllCachedPokemons() {
                        logApp("Using Cached DATA")
                        self?.outputEvents.send(.fetchListDidSucceed(pokemons: pokemonList))
                    } else {
                        self?.outputEvents.send(.fetchListDidFail(error: error))
                    }
                    self?.cancellables.removeAll()
                }
            } receiveValue: { [weak self] results in
                guard let `self` = self,
                      let results = results,
                      !results.toDomain().result.isEmpty
                else {
                    self?.outputEvents.send(.showEmpty)
                    return
                }
                self.handleResults(results: results)
            }
            .store(in: &cancellables)
    }

    func handleResults(results: PokemonListResponseDTO) {
        let domainResults = results.toDomain()
        updateNextPage(from: domainResults)
        updatePokemons(with: domainResults.result, cacheData: results)
        sendAppropriateOutputEvent(for: domainResults)
    }

    private func updateNextPage(from domainResults: PokemonPage) {
        nextPage = domainResults.next
    }

    private func updatePokemons(with newPokemons: [Pokemon], cacheData: PokemonListResponseDTO) {
        if pokemons == nil {
            pokemons = newPokemons
            saveCachePokemons(cacheData)
        } else {
            pokemons?.append(contentsOf: newPokemons)
        }
    }

    private func sendAppropriateOutputEvent(for domainResults: PokemonPage) {
        guard let currentPokemons = pokemons else {
            outputEvents.send(.showEmpty)
            return
        }

        if isFetchingMore {
            isFetchingMore = false
            outputEvents.send(.addNewResults(newPokemons: domainResults.result))
        } else {
            outputEvents.send(.fetchListDidSucceed(pokemons: currentPokemons))
        }
    }

    func searchPokemons(_ term: String) {
        guard let allPokemons = pokemons else {
            return
        }

        let lowercasedTerm = term.lowercased()

        if lowercasedTerm.isEmpty {
            outputEvents.send(.searchResults(pokemons: allPokemons))
            isSearching = false
            return
        }

        let matchingPokemons = allPokemons.filter { $0.name.lowercased().contains(lowercasedTerm) }

        if matchingPokemons.isEmpty {
            outputEvents.send(.showEmptySearchResults)
        } else {
            outputEvents.send(.searchResults(pokemons: matchingPokemons))
        }
    }
}
