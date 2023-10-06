//
//  DIContainer+Extension.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

extension DIContainer {
    func registration() {
        register(type: NetworkClientType.self, component: NetworkClient())
        guard let remoteService = PokemonDataRemoteService() else {
            debugLog("Missing PokemonDataRemoteService")
            return
        }
        register(type: PokemonDataRemoteServiceType.self, component: remoteService)

        guard let repository = PokemonRepository() else {
            debugLog("Missing PokemonRepository")
            return
        }
        register(type: PokemonRepositoryType.self, component: repository)

        register(type: CoreDataManagerProtocol.self, component: CoreDataManager())

        guard let pokemonListStorage = CoreDataPokemonListResponseStorage() else {
            debugLog("Missing CoreDataPokemonListResponseStorage")
            return
        }
        register(type: PokemonListResponseStorageType.self, component: pokemonListStorage)

        guard let fetchPokemonListUseCase = FetchPokemonListUseCase() else {
            debugLog("Missing FetchPokemonListUseCase")
            return
        }
        register(type: PokemonListUseCaseType.self, component: fetchPokemonListUseCase)
    }
}
