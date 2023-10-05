//
//  PokemonListViewController+SearchBarDelegate.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import UIKit

extension PokemonListViewController: UISearchBarDelegate {
    // User started editing the search text
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        input.send(.beginSearch)
    }

    // Text changed in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Text was cleared, likely due to cancel action
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            input.send(.cancelSearch)
        } else {
            searchTextSubject.send(searchText)
        }
    }

    // User tapped on the cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            searchBar.text = ""
        }
        input.send(.cancelSearch)
    }
}
