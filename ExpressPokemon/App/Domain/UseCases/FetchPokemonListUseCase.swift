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

    init(
        nextPageUrl: String? = nil,
        pokemonRepository: PokemonRepositoryType? = DIContainer.shared
            .inject(type: PokemonRepositoryType.self)
    ) throws {
        guard let pokemonRepository = pokemonRepository else {
            throw DIError.serviceNotFound
        }
        self.nextPageUrl = nextPageUrl
        self.pokemonRepository = pokemonRepository
    }

    func execute(nextPageUrl: String?) -> AnyPublisher<PokemonListResponseDTO?, APIError> {
        self.pokemonRepository.fetchPage(nextPageUrl: nextPageUrl)
    }
}
