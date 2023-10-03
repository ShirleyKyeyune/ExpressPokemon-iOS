//
//  APIError+Extension.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import Foundation

extension APIError {
    /// Provides a description of the error.
    var description: String {
        switch self {
        case .timeout:                    return MessageHelper.ServerError.timeOut
        case .noNetwork:                  return MessageHelper.ServerError.noNetwork
        case .clientError:                return MessageHelper.ServerError.clientError
        case .serverError:                return MessageHelper.ServerError.serverError
        case .redirection:                return MessageHelper.ServerError.redirection
        case .pageNotFound:               return MessageHelper.ServerError.notFound
        case .noData:                     return MessageHelper.ServerError.noData
        case .unauthorizedClient:         return MessageHelper.ServerError.unauthorizedClient
        case .invalidResponse:            return MessageHelper.ServerError.invalidResponse
        case .urlError:                   return MessageHelper.ServerError.urlError
        case .httpError:                  return MessageHelper.ServerError.httpError
        case .decodingError(let error):   return "Decoding Error: \(error.localizedDescription)"
        case .connectionError(let error): return "Network Connection Error: \(error.localizedDescription)"
        case .statusMessage(let message): return message
        case .custom(let error):          return error.localizedDescription
        case .unknown:                    return MessageHelper.ServerError.unknown
        case .general:                    return MessageHelper.ServerError.general
        }
    }
}

extension NetworkClient {
    static func errorType(forStatusCode statusCode: Int) -> APIError {
        switch statusCode {
        case 300..<400:
            return .redirection

        case 400..<500:
            return .clientError

        case 500..<600:
            return .serverError

        default:
            return otherErrorType(forStatusCode: statusCode)
        }
    }

    private static func otherErrorType(forStatusCode statusCode: Int) -> APIError {
        switch statusCode {
        case -1_001:
            return .timeout

        case -1_009:
            return .noNetwork

        default:
            return .unknown
        }
    }
}
