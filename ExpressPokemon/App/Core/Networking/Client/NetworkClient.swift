//
//  NetworkClient.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation
import Combine

final class NetworkClient: NetworkClientType {
    /// Initializes a new URL Session Client.
    ///
    /// - parameter urlSession: The URLSession to use.
    ///     Default: `URLSession(configuration: .shared)`.
    ///
    let session: URLSession
    let debugger: BaseAPIDebugger
    var subscriber = Set<AnyCancellable>()

    init(session: URLSession = .shared,
         debugger: BaseAPIDebugger = BaseAPIDebugger()) {
        self.session = session
        self.debugger = debugger
    }

    @discardableResult
    func perform<M, T>(with request: RequestBuilder,
                       decoder: JSONDecoder,
                       scheduler: T,
                       responseObject type: M.Type) -> AnyPublisher<M, APIError> where M: Decodable, T: Scheduler {
        guard let urlRequest = request.buildURLRequest() else {
            return Fail(error: APIError.clientError)
                        .eraseToAnyPublisher()
        }
        return publisher(request: urlRequest)
            .receive(on: scheduler)
            .tryMap { result, _ -> Data in
                result
            }
            .decode(type: type.self, decoder: decoder)
            .mapError { error in
                error as? APIError ?? .general
            }
            .eraseToAnyPublisher()
    }

    func publisher(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), APIError> {
        self.session.dataTaskPublisher(for: request)
            .mapError { APIError.urlError($0) }
            .map { response -> AnyPublisher<(data: Data, response: URLResponse), APIError> in
                guard let httpResponse = response.response as? HTTPURLResponse else {
                    return Fail(error: APIError.invalidResponse(httpStatusCode: 0))
                        .eraseToAnyPublisher()
                }

                if !httpResponse.isResponseOK {
                    let error = NetworkClient.errorType(forStatusCode: httpResponse.statusCode)
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }

                return Just(response)
                    .setFailureType(to: APIError.self)
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}

extension HTTPURLResponse {
    var isResponseOK: Bool {
        (200..<299).contains(statusCode)
    }
}
