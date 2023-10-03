//
//  PokemonRepositoryType.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation
import Combine

protocol PokemonRepositoryType {
    func fetchPage(nextPageUrl: String?) -> AnyPublisher<PokemonListResponseDTO?, APIError>
    func fetchDetails(for id: Int) -> AnyPublisher<PokemonDetailResponseDTO?, APIError>
}
