//
//  PokemonListDataRequest.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

struct PokemonListDataRequest: NetworkTarget {
    let parameters: [String: String]?

    init(parameters: [String: String]? = nil) {
        self.parameters = parameters
    }

    var baseURLEnv: BaseURLEnvironment {
        // TODO: switch to live API
        .local
    }

    var path: String? {
        "/api/v2/pokemon"
    }

    var methodType: HTTPMethod {
        .get
    }

    var queryParams: [String: String]? {
        parameters
    }

    var queryParamsEncoding: URLEncoding? {
        .default
    }
}
