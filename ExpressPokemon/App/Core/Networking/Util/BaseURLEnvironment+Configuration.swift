//
//  Configuration.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

enum BaseURLEnvironment {
    case production
    case local
    case custom(baseUrl: String)

    var baseURL: URL? {
        switch self {
        case .production:
            return URL(string: "https://pokeapi.co")

        case .local:
            return URL(string: "http://192.168.1.105:3005")

        case .custom(let url):
            return URL(string: url)
        }
    }
}

enum ImageBaseURL {
    case thumbnail
    case fullImage

    var url: String {
        switch self {
        case .thumbnail:
            return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/%@.png"
        case .fullImage:
            return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/%@.png"
        }
    }
}
