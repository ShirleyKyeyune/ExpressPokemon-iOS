//
//  PokemonDetailCoordinator.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import Foundation
import UIKit

class PokemonDetailCoordinator: NSObject, Coordinator {
    let navigationController: UINavigationController
    var coordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }

    deinit {
        // no-op
    }

    func start(pokemon: Pokemon) {
        DispatchQueue.main.async {
            guard let viewModel = PokemonDetailViewModel(pokemon: pokemon) else {
                return
            }
            let controller = PokemonDetailViewController(viewModel: viewModel)
            controller.delegate = self
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
}
