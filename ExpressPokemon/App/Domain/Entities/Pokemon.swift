//
//  Pokemon.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

struct Pokemon: Equatable, Identifiable {
    typealias Identifier = String

    let id: Identifier
    let name: String
    let url: String
    let thumbnailUrl: String?
    let fullImageUrl: String?
}

struct PokemonPage: Equatable {
    let count: Int
    let next: String?
    let result: [Pokemon]
}
