//
//  PokemonDetail.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let abilities: [PokemonAbility]
    let stats: [PokemonStat]
}

extension PokemonDetail {
    struct PokemonType: Decodable {
        let slot: Int
        let type: PokemonTypeDetail?
    }

    struct PokemonTypeDetail: Decodable {
        let name: String
        let url: String
    }

    struct PokemonStat: Decodable {
        let name: String
        let progress: Float
    }

    struct PokemonAbility: Decodable {
        let name: String
        let url: String
        let isHidden: Bool
        let slot: Int
    }
}
