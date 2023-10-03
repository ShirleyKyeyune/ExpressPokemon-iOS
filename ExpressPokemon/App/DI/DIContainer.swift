//
//  DIContainer.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

protocol DIContainerProtocol {
    func register<Service>(type: Service.Type, component: Any)
    func inject<Service>(type: Service.Type) -> Service?
}

final class DIContainer: DIContainerProtocol {
    static let shared = DIContainer()

    private init() {}

    private var services: [String: Any] = [:]
    private let lock = NSLock()  // For thread safety

    func register<Service>(type: Service.Type, component service: Any) {
        let key = String(describing: type)

        lock.lock()
        defer { lock.unlock() }

        services[key] = service
    }

    func inject<Service>(type: Service.Type) -> Service? {
        let key = String(describing: type)

        lock.lock()
        defer { lock.unlock() }

        return services[key] as? Service
    }
}
