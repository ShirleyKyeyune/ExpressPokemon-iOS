//
//  MainCoordinator+PokemonListDelegate.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import UIKit

extension MainCoordinator: PokemonListDelegate {
    func viewDidLoad(in viewController: PokemonListViewController) {
        // no-op
    }

    func viewWillAppear(in viewController: PokemonListViewController) {
        // no-op
    }

    func didSelectItem(pokemon: Pokemon, in viewController: PokemonListViewController) {
        // TODO: - move to details
    }
}
