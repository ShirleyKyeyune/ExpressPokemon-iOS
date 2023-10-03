//
//  PokemonDetailView+Extension.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import Foundation

extension PokemonDetailView: PokemonDetailViewType {
    func updateData(viewModel: PokemonDetailViewModelType) {
        self.viewModel = viewModel
        showLoadingView(isVisible: false)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func viewWillLayoutUpdate() {
        // no-op
    }

    func showLoadingView(isVisible: Bool) {
        loadingView.isHidden = !isVisible
        tableView.isHidden = isVisible
        errorView.isHidden = true
    }

    func showErrorView() {
        loadingView.isHidden = true
        tableView.isHidden = true
        errorView.isHidden = false
        errorView.setEmptyLabelText(Constants.AppState.error)
    }
}
