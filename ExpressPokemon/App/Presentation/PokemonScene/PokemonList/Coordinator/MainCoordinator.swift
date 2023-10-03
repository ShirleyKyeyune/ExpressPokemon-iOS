//
//  MainCoordinator.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 03/10/2023.
//

import Foundation
import UIKit

class MainCoordinator: NSObject, Coordinator {
    let window: UIWindow
    let navigationController: UINavigationController
    var coordinators: [Coordinator] = []

    init(window: UIWindow,
         navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.window = window

        super.init()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    deinit {
        // no-op
    }

    func start() {
        DispatchQueue.main.async {
            do {
                let viewModel = try PokemonViewModel()
                let controller = PokemonListViewController(viewModel: viewModel)
                controller.delegate = self
                self.navigationController.pushViewController(controller, animated: false)
            } catch {
                logApp(error.localizedDescription)
            }
        }
    }
}
