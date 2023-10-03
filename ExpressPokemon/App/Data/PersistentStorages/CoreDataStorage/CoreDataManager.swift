//
//  CoreDataManager.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 03/10/2023.
//

import Foundation
import CoreData
import Combine

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

extension NSManagedObject {
    class var entityName: String? {
        String(describing: self).components(separatedBy: ".").last
    }
}

protocol EntityCreating {
    var viewContext: NSManagedObjectContext { get }

    func createEntity<T: NSManagedObject>() -> T
}

extension EntityCreating {
    func createEntity<T: NSManagedObject>() -> T {
        T(context: viewContext)
    }
}

protocol CoreDataFetchProtocol {
    var viewContext: NSManagedObjectContext { get }

    func publisher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchResultsPublisher<T>
}

extension CoreDataFetchProtocol {
    func publisher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchResultsPublisher<T> {
        CoreDataFetchResultsPublisher(request: request, context: viewContext)
    }
}

protocol CoreDataSaveProtocol {
    var viewContext: NSManagedObjectContext { get }

    func publisher(save action: @escaping Action) -> CoreDataSaveModelPublisher
}

extension CoreDataSaveProtocol {
    func publisher(save action: @escaping Action) -> CoreDataSaveModelPublisher {
        CoreDataSaveModelPublisher(action: action, context: viewContext)
    }
}

protocol CoreDataDeleteModelPublishing {
    var viewContext: NSManagedObjectContext { get }

    func publisher(delete request: NSFetchRequest<NSFetchRequestResult>) -> CoreDataDeleteModelPublisher
}

extension CoreDataDeleteModelPublishing {
    func publisher(delete request: NSFetchRequest<NSFetchRequestResult>) -> CoreDataDeleteModelPublisher {
        CoreDataDeleteModelPublisher(delete: request, context: viewContext)
    }
}

protocol CoreDataManagerProtocol: EntityCreating,
                                  CoreDataFetchProtocol,
                                  CoreDataSaveProtocol,
                                  CoreDataDeleteModelPublishing {
    var viewContext: NSManagedObjectContext { get }
}

struct CoreDataManager: CoreDataManagerProtocol {
    var container: NSPersistentContainer

    static var preview: CoreDataManager = {
        let result = CoreDataManager(inMemory: false)
        return result
    }()

    var viewContext: NSManagedObjectContext {
        self.container.viewContext
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: Constants.DBName.coreData)
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                /*
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    init(container: NSPersistentContainer) {
        self.container = container
    }
}
