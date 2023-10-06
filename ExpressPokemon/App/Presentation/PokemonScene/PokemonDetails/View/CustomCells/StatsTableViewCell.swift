//
//  StatsTableViewCell.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import UIKit

class StatsTableViewCell: UITableViewCell {
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Labels.stats
        label.font = UIFont.systemFont(ofSize: AppSizes.textLarge, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let bodyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = AppSizes.paddingMini
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let noStatsLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Labels.statsNotAvailable
        label.font = UIFont.systemFont(ofSize: AppSizes.textMedium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        bodyStackView.addArrangedSubview(statsStackView)
        bodyStackView.addArrangedSubview(noStatsLabel)
        contentView.addSubview(headerLabel)
        contentView.addSubview(bodyStackView)

        headerLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        bodyStackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        let constraint = bodyStackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: AppSizes.paddingMini)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppSizes.paddingSmall),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSizes.paddingSmall),
            headerLabel.heightAnchor.constraint(equalToConstant: AppSizes.cellHeaderHeight),

            bodyStackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: AppSizes.paddingMini),
            bodyStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSizes.paddingSmall),
            bodyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppSizes.paddingSmall),
            bodyStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppSizes.paddingSmall)
        ])
    }

    // MARK: - Configure Stats
    func configureStats(_ stats: [PokemonDetail.PokemonStat]) {
        // Clear previous stats views
        for subview in statsStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }

        if stats.isEmpty {
            noStatsLabel.isHidden = false
            statsStackView.isHidden = true
        } else {
            noStatsLabel.isHidden = true
            statsStackView.isHidden = false
            for stat in stats {
                let statLabel = UILabel()
                statLabel.text = stat.name
                statLabel.widthAnchor.constraint(equalToConstant: AppSizes.statLabelWidth).isActive = true

                let statProgressView = StatProgressView()
                statProgressView.translatesAutoresizingMaskIntoConstraints = false
                statProgressView.setProgress(stat.progress)

                let rowStackView = UIStackView(arrangedSubviews: [statLabel, statProgressView])
                rowStackView.axis = .horizontal
                rowStackView.spacing = AppSizes.paddingMini

                statsStackView.addArrangedSubview(rowStackView)
            }
        }
    }

    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset the UI elements to their default state
        for subview in statsStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }

        noStatsLabel.isHidden = true
        statsStackView.isHidden = false
    }
}
