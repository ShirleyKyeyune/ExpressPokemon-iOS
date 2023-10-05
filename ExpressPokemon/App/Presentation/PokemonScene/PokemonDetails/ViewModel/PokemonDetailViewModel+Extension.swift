//
//  PokemonDetailViewModel+Extension.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import Combine

extension PokemonDetailViewModel: PokemonDetailViewModelType {
    var pageTitle: String {
        pokemon.name
    }

    var pokemonId: Int {
        Int(pokemon.id) ?? 0
    }

    var heroImageUrl: String? {
        pokemon.fullImageUrl
    }

    var commaSeparatedTypes: String {
        guard let types = pokemonDetail?.types,
              !types.isEmpty else {
            return "No Known types"
        }
        return types.compactMap { $0.type?.name.capitalized }.joined(separator: ", ")
    }

    var abilities: [String] {
        guard let abilities = pokemonDetail?.abilities,
              !abilities.isEmpty else {
            return []
        }
        let list = abilities.compactMap {
            $0.isHidden ? $0.name.capitalized : nil
        }
        return list
    }

    func transform(input: AnyPublisher<InputEvent, Never>) -> AnyPublisher<OutputEvent, Never> {
        input.sink { [weak self] event in
            guard let `self` = self else {
                return
            }
            switch event {
            case .viewDidAppear:
                self.fetchPokemonDetail(for: pokemonId)

            case .refreshDetailFired:
                self.fetchPokemonDetail(for: pokemonId)
            }
        }
        .store(in: &cancellables)
        return outputEvents.eraseToAnyPublisher()
    }

    func fetchPokemonDetail(for id: Int) {
        guard let pokemonRepository = pokemonRepository else {
            return
        }

        // Show loading state
        outputEvents.send(.showLoadingView(showLoading: true))

        // Fetch Pokemon detail
        pokemonRepository.fetchDetails(for: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.outputEvents.send(.fetchDetailDidFail(error: error))
                    self?.cancellables.removeAll()
                }
            } receiveValue: { [weak self] detail in
                guard let `self` = self else {
                    self?.outputEvents.send(.showLoadingView(showLoading: false))
                    return
                }
                self.pokemonDetail = detail?.toDomain()
                if let pokemonDetail = self.pokemonDetail {
                    self.outputEvents.send(.fetchDetailDidSucceed(pokemonDetail: pokemonDetail))
                } else {
                    self.outputEvents.send(.fetchDetailDidFail(error: CustomError(description: "Detail Fetch Failed", code: 0)))
                }
            }
            .store(in: &cancellables)
    }
}
