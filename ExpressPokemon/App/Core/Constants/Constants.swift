//
//  Constants.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

enum Constants {
    enum DBName {
        static let coreData: String = "ExpressPokemon"
        static let pokemonEntity: String = "PokemonEntity"
    }
    enum Title {
        static let mainTitle: String = "Express Pokemon"
    }
    enum PlaceHolder {
        static let search: String = "Search Pokemon"
    }
    enum AppState {
        static let loading: String = "Loading..."
        static let empty: String = "No data available at the moment."
        static let emptySearchResults: String = "Sorry, we couldn't find any matches for your search query."
        static let error: String = "Sorry, we couldn't load Pokemons. Check your internet connection and try again."
    }
}
