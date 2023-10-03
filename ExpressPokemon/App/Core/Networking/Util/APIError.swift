//
//  APIError.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

enum APIError: Error {
    case timeout
    case noNetwork
    case clientError
    case serverError
    case redirection
    case pageNotFound
    case noData
    case unauthorizedClient
    case invalidResponse(httpStatusCode: Int)
    case urlError(URLError)
    case httpError(HTTPURLResponse)
    case decodingError(Error)
    case connectionError(Error)
    case statusMessage(message: String)
    case custom(Error)
    case unknown
    case general
}
