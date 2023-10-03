//
//  PokemonDetailResponseDTO+Mapping.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

// MARK: - Data Transfer Object

struct PokemonDetailResponseDTO: Decodable {
    let id: Int?
    let order: Int?
    let name: String?
    let height: Int?
    let weight: Int?
    let types: [PokemonTypeResponseDTO]?
    let abilities: [PokemonAbilityResponseDTO]?
    let baseExperience: Int?
    let stats: [PokemonStatResponseDTO]?
}

extension PokemonDetailResponseDTO {
    struct PokemonTypeResponseDTO: Decodable {
        let slot: Int?
        let type: PokemonTypeDetailResponseDTO?
    }

    struct PokemonTypeDetailResponseDTO: Decodable {
        let name: String?
        let url: String?
    }

    struct PokemonAbilityResponseDTO: Decodable {
        let ability: PokemonAbilityDetailResponseDTO?
        let isHidden: Bool?
        let slot: Int?
    }

    struct PokemonAbilityDetailResponseDTO: Decodable {
        let name: String?
        let url: String?
    }

    struct PokemonStatResponseDTO: Decodable {
        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case effort = "effort"
            case stat = "stat"
        }

        let baseStat: Int?
        let effort: Int?
        let stat: PokemonStatDetailResponseDTO?
    }

    struct PokemonStatDetailResponseDTO: Decodable {
        let name: String?
        let url: String?
    }
}

extension PokemonDetailResponseDTO.PokemonStatResponseDTO {
    func decode(from decoder: Decoder) throws -> Self {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let baseStat = try container.decodeIfPresent(Int.self, forKey: .baseStat)
        let effort = try container.decodeIfPresent(Int.self, forKey: .effort)
        let stat = try container.decodeIfPresent(
            PokemonDetailResponseDTO.PokemonStatDetailResponseDTO.self,
            forKey: .stat
        )

        return Self(baseStat: baseStat, effort: effort, stat: stat)
    }
}

// MARK: - Mappings to Domain

extension PokemonDetailResponseDTO {
    func toDomain() -> PokemonDetail? {
        let abilities = abilities ?? []
        let types = types ?? []
        let stats = stats ?? []

        let pokemonAbilities = abilities.compactMap { $0.toDomain() }
        let pokemonTypes = types.compactMap { $0.toDomain() }
        let pokemonStats = stats.compactMap { $0.toDomain() }
        return PokemonDetail(
            id: self.id ?? 0,
            name: self.name ?? "",
            height: self.height ?? 0,
            weight: self.weight ?? 0,
            types: pokemonTypes,
            abilities: pokemonAbilities,
            stats: pokemonStats
        )
    }
}

extension PokemonDetailResponseDTO.PokemonTypeResponseDTO {
    func toDomain() -> PokemonDetail.PokemonType? {
        guard let slot = slot,
              let type = type?.toDomain() else {
            return nil
        }

        return PokemonDetail.PokemonType(
            slot: slot,
            type: type
        )
    }
}

extension PokemonDetailResponseDTO.PokemonTypeDetailResponseDTO {
    func toDomain() -> PokemonDetail.PokemonTypeDetail? {
        guard let name = name,
              let url = url else {
            return nil
        }

        return PokemonDetail.PokemonTypeDetail(
            name: name,
            url: url
        )
    }
}

extension PokemonDetailResponseDTO.PokemonStatResponseDTO {
    func toDomain() -> PokemonDetail.PokemonStat? {
        guard let baseStat = baseStat,
              let name = stat?.name?.capitalized
        else {
            return nil
        }
        let progress = (Float(baseStat) / 100.0)

        return PokemonDetail.PokemonStat(name: name, progress: progress)
    }
}

extension PokemonDetailResponseDTO.PokemonAbilityResponseDTO {
    func toDomain() -> PokemonDetail.PokemonAbility? {
        guard let name = ability?.name,
              let url = ability?.url,
              let isHidden = isHidden,
              let slot = slot else {
            return nil
        }

        return PokemonDetail.PokemonAbility(
            name: name,
            url: url,
            isHidden: isHidden,
            slot: slot
        )
    }
}

extension Float {
  func roundedUp() -> Float {
    self >= 0 ? floor(self + 0.5) : ceil(self - 0.5)
  }
}
