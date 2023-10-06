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
            let error = APIError.clientError
            errorLog(error)
            return Fail(error: error)
                        .eraseToAnyPublisher()
        }
        infoLog(urlRequest)

        return publisher(request: urlRequest)
            .receive(on: scheduler)
            .tryMap { result, _ -> Data in
                guard let json = try? JSONSerialization.jsonObject(with: result, options: []) else {
                    // This is not JSON data; you may want to handle the error or just return the data as-is
                    return result
                }

                infoLog("JSON Response: \(json)")

                return result
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
                    let error = APIError.invalidResponse(httpStatusCode: 0)
                    errorLog(error.localizedDescription)
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }

                if !httpResponse.isResponseOK {
                    let error = NetworkClient.errorType(forStatusCode: httpResponse.statusCode)
                    errorLog(error.localizedDescription)
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }

                infoLog(response.response)
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
