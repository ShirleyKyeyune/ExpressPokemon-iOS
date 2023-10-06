//
//  PokemonDetail.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

struct PokemonDetail: Identifiable {
    typealias Identifier = Int

    let id: Identifier
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let abilities: [PokemonAbility]
    let stats: [PokemonStat]
}

extension PokemonDetail: Equatable {
    static func == (lhs: PokemonDetail, rhs: PokemonDetail) -> Bool {
        lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.height == rhs.height &&
               lhs.weight == rhs.weight &&
               lhs.types == rhs.types &&
               lhs.abilities == rhs.abilities &&
               lhs.stats == rhs.stats
    }
}

extension PokemonDetail {
    struct PokemonType: Identifiable {
        typealias Identifier = String

        let id: Identifier
        let slot: Int
        let type: PokemonTypeDetail?
    }

    struct PokemonTypeDetail: Equatable, Identifiable {
        typealias Identifier = String

        let id: Identifier
        let name: String
        let url: String
    }

    struct PokemonStat: Equatable, Identifiable {
        typealias Identifier = String

        let id: Identifier
        let name: String
        let progress: Float
    }

    struct PokemonAbility: Equatable, Identifiable {
        typealias Identifier = String

        let id: Identifier
        let name: String
        let url: String
        let slot: Int
    }
}

extension PokemonDetail.PokemonType: Equatable {
    static func == (lhs: PokemonDetail.PokemonType, rhs: PokemonDetail.PokemonType) -> Bool {
        lhs.id == rhs.id &&
               lhs.slot == rhs.slot &&
               lhs.type == rhs.type
    }
}
