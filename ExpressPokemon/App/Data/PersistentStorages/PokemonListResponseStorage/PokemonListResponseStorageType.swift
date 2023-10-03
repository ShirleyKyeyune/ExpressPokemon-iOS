//
//  PokemonListResponseStorageType.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 05/10/2023.
//

import Combine

protocol PokemonListResponseStorageType {
    func findByName(_ name: String) -> PokemonEntity?

    func fetch() -> [PokemonEntity]?

    func save(_ item: PokemonListResponseDTO.PokemonResponseDTO)

    func save(_ items: [PokemonListResponseDTO.PokemonResponseDTO])

    func deleteByName(_ name: String)

    func batchDelete(byNames names: [String]?)
}
