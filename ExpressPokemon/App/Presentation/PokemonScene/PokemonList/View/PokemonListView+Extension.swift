//
//  PokemonListView+Extension.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import Foundation

extension PokemonListView: PokemonListViewType {
    func updateData(pokemons: [Pokemon]) {
        self.pokemons = pokemons
        showLoadingView(isVisible: false)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func viewWillLayoutUpdate() {
        // no-op
    }

    func showLoadingView(isVisible: Bool) {
        searchBar.isHidden = isVisible
        searchEmptyView.isHidden = true
        emptyView.isHidden = true
        loadingView.isHidden = !isVisible
        loadingMoreView.isHidden = true
        collectionView.isHidden = isVisible
    }

    func showLoadingMoreView(isVisible: Bool) {
        searchBar.isHidden = isVisible
        searchEmptyView.isHidden = true
        emptyView.isHidden = true
        loadingView.isHidden = false
        loadingMoreView.isHidden = !isVisible
        collectionView.isHidden = false
    }

    func showEmptyView() {
        searchBar.isHidden = true
        searchEmptyView.isHidden = true
        emptyView.isHidden = false
        loadingView.isHidden = true
        loadingMoreView.isHidden = true
        collectionView.isHidden = true
    }

    func showSearchEmptyView() {
        searchBar.isHidden = false
        searchEmptyView.isHidden = false
        emptyView.isHidden = true
        loadingView.isHidden = true
        loadingMoreView.isHidden = true
        collectionView.isHidden = true
    }

    func showErrorView() {
        searchBar.isHidden = true
        searchEmptyView.isHidden = true
        emptyView.isHidden = false
        loadingView.isHidden = true
        loadingMoreView.isHidden = true
        collectionView.isHidden = true
        emptyView.setEmptyLabelText(Constants.AppState.error)
    }
}
