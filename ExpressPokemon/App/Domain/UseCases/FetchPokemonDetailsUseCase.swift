//
//  FetchPokemonDetailsUseCase.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 03/10/2023.
//

import Foundation
import Combine

final class FetchPokemonDetailsUseCase: PokemonDetailsUseCaseType {
    private let id: Int
    private let pokemonRepository: PokemonRepositoryType

    init?(
        id: Int,
        pokemonRepository: PokemonRepositoryType? = injected(PokemonRepositoryType.self)
    ) throws {
        guard let pokemonRepository = pokemonRepository else {
            return nil
        }
        self.id = id
        self.pokemonRepository = pokemonRepository
    }

    func execute(for id: Int) -> AnyPublisher<PokemonDetailResponseDTO?, APIError> {
        self.pokemonRepository.fetchDetails(for: id)
    }
}
