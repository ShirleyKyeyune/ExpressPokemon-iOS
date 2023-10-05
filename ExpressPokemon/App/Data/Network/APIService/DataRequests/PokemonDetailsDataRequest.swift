//
//  PokemonDetailsDataRequest.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

struct PokemonDetailsDataRequest: NetworkTarget {
    let id: Int

    init(id: Int) {
        self.id = id
    }

    var baseURLEnv: BaseURLEnvironment {
        .production
    }

    var path: String? {
        "api/v2/pokemon/\(id)/"
    }

    var queryParams: [String: String]? {
        nil
    }

    var methodType: HTTPMethod {
        .get
    }

    var queryParamsEncoding: URLEncoding? {
        .default
    }
}
