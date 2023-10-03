//
//  PokemonDataRemoteService.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation
import Combine

final class PokemonDataRemoteService: NetworkingClientManager<HttpRequest>, PokemonDataRemoteServiceType {
    func fetchPage(nextPageUrl: String?) -> AnyPublisher<PokemonListResponseDTO?, APIError> {
        guard
            let nextPageUrl = nextPageUrl,
            let url = URL(string: nextPageUrl),
            let parameters = url.queryParameters
        else {
            // default first api call doesn't specify other parameters
            let request = HttpRequest(request: PokemonListDataRequest())
            return initiateRequest(
                request: request,
                scheduler: WorkScheduler.mainScheduler,
                responseType: PokemonListResponseDTO?.self
            )
        }

        let request = HttpRequest(request: PokemonListDataRequest(parameters: parameters))
        return initiateRequest(
            request: request,
            scheduler: WorkScheduler.mainScheduler,
            responseType: PokemonListResponseDTO?.self
        )
    }

    func fetchDetails(id: Int) -> AnyPublisher<PokemonDetailResponseDTO?, APIError> {
        let request = HttpRequest(request: PokemonDetailsDataRequest(id: id))

        return self.initiateRequest(
            request: request,
            scheduler: WorkScheduler.mainScheduler,
            responseType: PokemonDetailResponseDTO?.self
        )
    }
}
