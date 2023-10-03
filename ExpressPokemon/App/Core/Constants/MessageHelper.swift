//
//  MessageHelper.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

enum MessageHelper {
    enum ServerError {
        static let general: String = "Bad Request"
        static let noNetwork: String = "Check the Connection"
        static let timeOut: String = "Timeout"
        static let notFound: String = "No Result"
        static let serverError: String = "Internal Server Error"
        static let redirection: String = "Request doesn't seem to be proper."
        static let clientError: String = "Request doesn't seem to be proper."
        static let invalidResponse: String = "Invalid Server Response"
        static let unauthorizedClient: String = "Unauthorized Client"
        static let unknown: String = "Unknown error"
        static let httpError: String = "Unknown HTTP Error"
        static let noData: String = "No data received from the server."
        static let urlError: String = "The URL can’t be loaded."
    }
}
