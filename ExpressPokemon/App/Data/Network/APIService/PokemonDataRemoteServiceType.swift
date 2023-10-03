//
//  PokemonDataRemoteServiceType.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation
import Combine

protocol PokemonDataRemoteServiceType: AnyObject {
    func fetchPage(nextPageUrl: String?) -> AnyPublisher<PokemonListResponseDTO?, APIError>
    func fetchDetails(id: Int) -> AnyPublisher<PokemonDetailResponseDTO?, APIError>
}
