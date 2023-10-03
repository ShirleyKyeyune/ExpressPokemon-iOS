//
//  PokemonViewModel+Cache.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 05/10/2023.
//

import Foundation

extension PokemonViewModel {
    func saveCachePokemons(_ pokemonResponse: PokemonListResponseDTO) {
        guard let items = pokemonResponse.results else {
            return
        }
        pokemonCacheRepository.save(items)
    }

    func deleteAllCachedPokemons() {
        pokemonCacheRepository.batchDelete(byNames: nil)
    }

    func fetchAllCachedPokemons() -> [Pokemon]? {
        let pokemons = pokemonCacheRepository.fetch()
        let responseItems = pokemons?.compactMap {
            PokemonListResponseDTO.PokemonResponseDTO(name: $0.name, url: $0.url)
        }

        return responseItems?.compactMap {
            $0.toDomain()
        }
    }
}
