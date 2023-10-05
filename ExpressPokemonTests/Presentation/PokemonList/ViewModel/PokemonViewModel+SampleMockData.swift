//
//  PokemonViewModel+SampleMockData.swift
//  ExpressPokemonTests
//
//  Created by Shirley Kyeyune on 05/10/2023.
//

@testable import ExpressPokemon

let samplePokemonResponseDTO1 = PokemonListResponseDTO.PokemonResponseDTO(
    name: "Bulbasaur",
    url: "https://pokeapi.co/api/v2/pokemon/1/"
)
let samplePokemonResponseDTO2 = PokemonListResponseDTO.PokemonResponseDTO(
    name: "Ivysaur",
    url: "https://pokeapi.co/api/v2/pokemon/2/"
)
let samplePokemonListResponseDTO = PokemonListResponseDTO(
    count: 2,
    next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
    results: [samplePokemonResponseDTO1, samplePokemonResponseDTO2]
)

let samplePokemon1 = Pokemon(
    id: "1",
    name: "Bulbasaur",
    url: "https://pokeapi.co/api/v2/pokemon/1/",
    thumbnailUrl: nil,
    fullImageUrl: nil
)
let samplePokemon2 = Pokemon(
    id: "2",
    name: "Ivysaur",
    url: "https://pokeapi.co/api/v2/pokemon/2/",
    thumbnailUrl: nil,
    fullImageUrl: nil
)

let samplePokemonPage = PokemonPage(
    count: 2,
    next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
    result: [samplePokemon1, samplePokemon2]
)
