//
//  PokemonRepository.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation
import Combine

final class PokemonRepository: PokemonRepositoryType {
    private let service: PokemonDataRemoteServiceType

    init?(service: PokemonDataRemoteServiceType? = injected(PokemonDataRemoteServiceType.self)) {
        guard let service = service else {
            return nil
        }
        self.service = service
    }

    func fetchPage(nextPageUrl: String?) -> AnyPublisher<PokemonListResponseDTO?, APIError> {
        self.service.fetchPage(nextPageUrl: nextPageUrl)
    }

    func fetchDetails(for id: Int) -> AnyPublisher<PokemonDetailResponseDTO?, APIError> {
        self.service.fetchDetails(id: id)
    }
}
