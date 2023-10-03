//
//  NetworkingClientManager.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation
import Combine

class NetworkingClientManager<K: RequestBuilder> {
    typealias PublisherResult<M> = AnyPublisher<M, APIError>

    // The session client is utilised to initiate requests using URLSession Data Task Publisher
    private let sessionClient: NetworkClientType

    init(sessionClient: NetworkClientType? = DIContainer.shared.inject(type: NetworkClientType.self)) throws {
        guard let sessionClient = sessionClient else {
            throw DIError.serviceNotFound
        }
        self.sessionClient = sessionClient
    }

    func initiateRequest<M, T>(
        request: K,
        scheduler: T,
        responseType type: M.Type,
        decoder: JSONDecoder = .init()
    ) -> PublisherResult<M> where M: Decodable, T: Scheduler {
        sessionClient.perform(with: request, decoder: decoder, scheduler: scheduler, responseObject: type)
    }
}
