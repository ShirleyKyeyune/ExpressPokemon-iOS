//
//  Data.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import Foundation

extension Data {
    var printableJSON: String? {
        (try? JSONSerialization.jsonObject(with: self))
            .flatMap { try? JSONSerialization.data(withJSONObject: $0, options: [.prettyPrinted]) }
            .flatMap { String(data: $0, encoding: .utf8) }
    }
}
