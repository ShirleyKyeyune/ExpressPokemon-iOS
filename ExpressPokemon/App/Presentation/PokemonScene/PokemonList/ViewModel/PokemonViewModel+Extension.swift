//
//  PokemonViewModel+Extension.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import Combine

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

            case .loadMore(let lastScrollPosition):
                self.lastScrollPosition = lastScrollPosition
                self.fetchPokemons(self.nextPage)

            case .searchFired(let term):
                self.searchPokemons(term)
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
                let pokemonPage = results.toDomain()
                let pokemonList = pokemonPage.result
                self.nextPage = pokemonPage.next
                if self.pokemons == nil {
                    self.pokemons = pokemonList
                    // save locally
                    saveCachePokemons(results)
                } else {
                    self.pokemons?.append(contentsOf: pokemonList)
                }

                if let pokemonList = self.pokemons {
                    self.outputEvents.send(.fetchListDidSucceed(pokemons: pokemonList))
                } else {
                    self.outputEvents.send(.showEmpty)
                }
            }
            .store(in: &cancellables)
    }

    func searchPokemons(_ term: String) {
        guard let allPokemons = pokemons else {
            return
        }

        let lowercasedTerm = term.lowercased()

        if lowercasedTerm.isEmpty {
            outputEvents.send(.searchResults(pokemons: allPokemons))
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
