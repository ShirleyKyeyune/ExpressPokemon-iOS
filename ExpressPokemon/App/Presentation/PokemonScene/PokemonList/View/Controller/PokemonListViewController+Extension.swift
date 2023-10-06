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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.pokemonCell, for: indexPath) as? PokemonCell
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

extension PokemonListViewController: UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let mainView = mainView as? PokemonListView else { return }

        let lastItem = mainView.pokemons.count - 1

        if indexPath.item == lastItem {
            // If we are not already fetching more items, fetch more.
            guard viewModel.shouldFetchMoreItems else { return }

            // Trigger data fetching
            input.send(.loadMore)
        }
    }
}

extension PokemonListViewController {
    func didFailWithError(error: Error) {
        let builder = AlertViewBuilder()
        let alert = builder
            .erase()
            .build(title: Constants.Title.failure, message: error.localizedDescription, preferredStyle: .alert)
            .buildAction(title: Constants.Title.tryAgain, style: .default) { [weak self] (_: UIAlertAction) in
                print("OK button tapped.")
                guard let `self` = self else {
                    return
                }
                self.input.send(.refreshListFired)
            }
            .buildAction(title: Constants.Title.cancel, style: .cancel, handler: nil)
            .content

        self.present(alert, animated: true)
    }
}
