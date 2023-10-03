//
//  Coordinator.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 03/10/2023.
//

import Foundation

public protocol Coordinator: AnyObject {
    var coordinators: [Coordinator] { get set }
}

public extension Coordinator {
    func addCoordinator(_ coordinator: Coordinator) {
        coordinators.append(coordinator)
    }

    func removeCoordinator(_ coordinator: Coordinator) {
        assert(coordinator !== self)
        guard coordinator !== self else { return }
        coordinators = coordinators.filter { $0 !== coordinator }
    }

    func removeAllCoordinators() {
        coordinators.removeAll()
    }

    private func coordinatorOfType<T: Coordinator>(coordinator: Coordinator, type: T.Type) -> T? {
        if let value = coordinator as? T {
            return value
        } else {
            return coordinator.coordinators.compactMap { coordinatorOfType(coordinator: $0, type: type) }.first
        }
    }

    func coordinatorOfType<T: Coordinator>(type: T.Type) -> T? {
        coordinatorOfType(coordinator: self, type: type)
    }
}
