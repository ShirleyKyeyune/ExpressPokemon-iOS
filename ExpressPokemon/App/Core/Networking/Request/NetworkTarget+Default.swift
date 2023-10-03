//
//  NetworkTarget+Default.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

extension NetworkTarget {
    var bodyEncoding: BodyEncoding? {
        nil
    }

    var parameters: [String: Any]? {
       nil
    }

    var cachePolicy: URLRequest.CachePolicy? {
        .useProtocolCachePolicy
    }

    var timeoutInterval: TimeInterval? {
        20.0
    }

    var headers: [String: String]? {
        ["accept": "application/json"]
    }
}
