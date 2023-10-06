//
//  PokemonDetailViewController+Extension.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import UIKit

extension PokemonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return configureHeroImageCell(in: tableView, for: indexPath)

        case 1:
            return configureDetailCell(in: tableView, for: indexPath)

        case 2:
            return configureAbilitiesCell(in: tableView, for: indexPath)

        case 3:
            return configureStatsCell(in: tableView, for: indexPath)

        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        nil
    }

    private func configureHeroImageCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.Cells.heroImageTableViewCell,
            for: indexPath
        ) as? HeroImageTableViewCell,
              let pokemon = mainView.viewModel?.pokemon else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.titleLabel.text = pokemon.name
        cell.heroImageView.loadRemoteImage(pokemon.fullImageUrl ?? "") { [weak cell] loadedImage in
            DispatchQueue.main.async {
                if cell?.tag == indexPath.item {
                    cell?.configureImageBgColor(loadedImage: loadedImage)
                }
            }
        }
        return cell
    }

    private func configureDetailCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.Cells.detailTableViewCell,
            for: indexPath
        ) as? DetailTableViewCell,
              let viewModel = mainView.viewModel,
              let details = viewModel.pokemonDetail else {
            return UITableViewCell()
        }
        cell.heightValueLabel.text = "\(details.height)"
        cell.weightValueLabel.text = "\(details.weight)"
        cell.typesValueLabel.text = viewModel.commaSeparatedTypes
        return cell
    }

    private func configureAbilitiesCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.Cells.abilitiesTableViewCell,
            for: indexPath
        ) as? AbilitiesTableViewCell,
              let viewModel = mainView.viewModel else {
            return UITableViewCell()
        }
        cell.configureAbilities(viewModel.abilities)
        return cell
    }

    private func configureStatsCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.Cells.statsTableViewCell,
            for: indexPath
        ) as? StatsTableViewCell,
              let viewModel = mainView.viewModel,
              let stats = viewModel.pokemonDetail?.stats else {
            return UITableViewCell()
        }
        cell.configureStats(stats)
        return cell
    }
}

extension PokemonDetailViewController: HeroImageTableViewCellDelegate {
    func viewDidLoadImage(imageColor: UIColor, in tableViewCell: HeroImageTableViewCell) {
        self.navigationController?.changeStatusBarColor(backgroundColor: imageColor)
    }
}
