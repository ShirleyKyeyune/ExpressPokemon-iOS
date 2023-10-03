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
        do {
            let remoteService = try PokemonDataRemoteService()
            register(type: PokemonDataRemoteServiceType.self, component: remoteService)

            let repository = try PokemonRepository()
            register(type: PokemonRepositoryType.self, component: repository)

            register(type: CoreDataManagerProtocol.self, component: CoreDataManager())
            let pokemonListStorage = try CoreDataPokemonListResponseStorage()
            register(type: PokemonListResponseStorageType.self, component: pokemonListStorage)

            let fetchPokemonListUseCase = try FetchPokemonListUseCase()
            register(type: PokemonListUseCaseType.self, component: fetchPokemonListUseCase)
        } catch {
            logApp(error.localizedDescription)
        }
    }
}
