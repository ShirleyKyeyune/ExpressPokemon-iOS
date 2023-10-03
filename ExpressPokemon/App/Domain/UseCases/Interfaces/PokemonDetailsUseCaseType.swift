//
//  PokemonDetailsUseCaseType.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation
import Combine

protocol PokemonDetailsUseCaseType {
    func execute(for id: Int) -> AnyPublisher<PokemonDetailResponseDTO?, APIError>
}
