//
//  PokemonListUseCaseType.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation
import Combine

protocol PokemonListUseCaseType: AnyObject {
    func execute(nextPageUrl: String?) -> AnyPublisher<PokemonListResponseDTO?, APIError>
}
