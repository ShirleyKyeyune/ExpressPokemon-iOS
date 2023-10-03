//
//  PokemonListViewController+Extension.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import UIKit

// MARK: - UICollectionViewDataSource
 extension PokemonListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = (mainView as? PokemonListView)?.pokemons.count
        return count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as? PokemonCell
        cell?.tag = indexPath.item
        guard let cell = cell,
              let mainView = mainView as? PokemonListView,
              !mainView.pokemons.isEmpty else {
            return UICollectionViewCell()
        }

        let pokemon = mainView.pokemons[indexPath.item]
        cell.cellNameLabel.text = pokemon.name

        cell.cellImageView.loadRemoteImage(pokemon.thumbnailUrl ?? "") { [weak cell] loadedImage in
                DispatchQueue.main.async {
                    if cell?.tag == indexPath.item {
                        cell?.configureImageBgColor(loadedImage: loadedImage)
                    }
                }
        }

        return cell
    }
 }

// MARK: - UICollectionViewDelegate
 extension PokemonListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let mainView = mainView as? PokemonListView,
              !mainView.pokemons.isEmpty else {
            return
        }
        let pokemon = mainView.pokemons[indexPath.item]

        if let navigationController = navigationController {
            let pokemonDetailCoordinator = PokemonDetailCoordinator(navigationController: navigationController)
            pokemonDetailCoordinator.start(pokemon: pokemon)
        }
    }
 }


extension PokemonListViewController {
    func didFailWithError(error: Error) {
        let alert = AlertViewBuilder()
            .build(title: "Failure!", message: error.localizedDescription, preferredStyle: .alert)
            .build(title: "Try again", style: .default) {_ in
                self.errorSubject.send()
            }
            .content

        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
