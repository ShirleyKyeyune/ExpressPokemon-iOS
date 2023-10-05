//
//  CoreDataPokemonListResponseStorage.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 05/10/2023.
//

import Foundation
import CoreData
import Combine

final class CoreDataPokemonListResponseStorage: PokemonListResponseStorageType {
    private let coreDataManager: CoreDataManagerProtocol
    var cancellables = Set<AnyCancellable>()


    init(coreDataManager: CoreDataManagerProtocol? = DIContainer.shared.inject(type: CoreDataManagerProtocol.self)) throws {
        guard let coreDataManager = coreDataManager else {
            throw DIError.serviceNotFound
        }
        self.coreDataManager = coreDataManager
    }

    func saveItems(_ items: [PokemonListResponseDTO.PokemonResponseDTO]) {
        let action: Action = {
            items.forEach { item in
                if let name = item.name, let matchData = self.findByName(name) {
                    matchData.url = item.url
                    matchData.name = item.name
                } else {
                    let coin = NSEntityDescription.insertNewObject(
                        forEntityName: Constants.DBName.pokemonEntity,
                        into: self.coreDataManager.viewContext
                    )
                    coin.setValue(item.url, forKey: "url")
                    coin.setValue(item.name, forKey: "name")
                }
            }
        }

        performCoreDataOperation(with: action)
    }

    func save(_ item: PokemonListResponseDTO.PokemonResponseDTO) {
        let action: Action = {
            if let name = item.name, let matchData = self.findByName(name) {
                matchData.url = item.url
                matchData.name = item.name
            } else {
                let coin = NSEntityDescription.insertNewObject(
                    forEntityName: Constants.DBName.pokemonEntity,
                    into: self.coreDataManager.viewContext
                )
                coin.setValue(item.url, forKey: "url")
                coin.setValue(item.name, forKey: "name")
            }
        }

        performCoreDataOperation(with: action)
    }

    private func performCoreDataOperation(with action: @escaping Action) {
        self.coreDataManager
            .publisher(save: action)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    logApp("Core Data Operation Failure: \(error)")

                case .finished:
                    logApp("Completion")
                }
            } receiveValue: { success in
                if success {
                    logApp("Core Data Operation Done")
                }
            }
            .store(in: &cancellables)
    }

    func fetch() -> [PokemonEntity]? {
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        var output: [PokemonEntity] = []
        self.coreDataManager
            .publisher(fetch: request)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    logApp("FetchData Failure: \(error)")

                case .finished:
                    logApp("Completion")
                }
            } receiveValue: { value in
                output.append(contentsOf: value)
            }
            .store(in: &cancellables)
        return output
    }

    func findByName(_ name: String) -> PokemonEntity? {
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        let idPredicate = NSPredicate(format: "name == %@", name)
        request.predicate = idPredicate
        var output: PokemonEntity?
        self.coreDataManager
            .publisher(fetch: request)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    logApp("FetchData Failure: \(error)")

                case .finished:
                    logApp("Completion")
                }
            } receiveValue: { value in
                output = value.first
            }
            .store(in: &cancellables)
        return output
    }

    func deleteByName(_ name: String) {
        guard let entityName = PokemonEntity.entityName else {
            return
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let idPredicate = NSPredicate(format: "name == %@", name)
        request.predicate = idPredicate
        self.coreDataManager
            .publisher(delete: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    logApp("Delete Failure: \(error)")

                case .finished:
                    logApp("Completion")
                }
            } receiveValue: { _ in
            }
            .store(in: &cancellables)
    }

    func batchDelete(byNames names: [String]? = nil) {
        var predicate: NSPredicate?
        if let names = names, !names.isEmpty {
            predicate = NSPredicate(format: "name IN %@", names)
        }

        let publisher = CoreDataBatchDeleteModelsPublisher<PokemonEntity>(
            delete: predicate,
            context: self.coreDataManager.viewContext
        )

        publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    logApp("Batch Delete Failure: \(error)")

                case .finished:
                    logApp("Batch Delete Completion")
                }
            } receiveValue: { result in
                if let deletedCount = result.result as? Int {
                    logApp("Batch Delete Done, deleted \(deletedCount) items")
                }
            }
            .store(in: &cancellables)
    }
}
