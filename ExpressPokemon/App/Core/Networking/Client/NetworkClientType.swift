//
//  NetworkClientType.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation
import Combine

typealias BaseAPIProtocol = NetworkClientType & DebuggerProtocol

typealias AnyPublisherResult<M> = AnyPublisher<M, APIError>

protocol NetworkClientType: AnyObject {
    /// Executes the specified request.
    ///
    /// - parameter request: The request to be executed.
    /// - parameter completion: A callback to be invoked upon request completion.

    var session: URLSession { get }

    @available(iOS 13.0, *)
    @discardableResult
    func perform<M: Decodable, T>(with request: RequestBuilder,
                                  decoder: JSONDecoder,
                                  scheduler: T,
                                  responseObject type: M.Type)
    -> AnyPublisher<M, APIError> where M: Decodable, T: Scheduler
}

protocol DebuggerProtocol {
    var debugger: BaseAPIDebugger { get }
}
