//
//  FetchPokemonListUseCase.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation
import Combine

final class FetchPokemonListUseCase: PokemonListUseCaseType {
    private let nextPageUrl: String?
    private let pokemonRepository: PokemonRepositoryType

    init?(
        nextPageUrl: String? = nil,
        pokemonRepository: PokemonRepositoryType? = injected(PokemonRepositoryType.self)
    ) {
        guard let pokemonRepository = pokemonRepository else {
            return nil
        }
        self.nextPageUrl = nextPageUrl
        self.pokemonRepository = pokemonRepository
    }

    func execute(nextPageUrl: String?) -> AnyPublisher<PokemonListResponseDTO?, APIError> {
        self.pokemonRepository.fetchPage(nextPageUrl: nextPageUrl)
    }
}
