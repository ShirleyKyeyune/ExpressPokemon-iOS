//
//  DIError+Extension.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import Foundation

extension DIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serviceNotFound:
            return "DI Error: The requested service was not found."
        }
    }
}
