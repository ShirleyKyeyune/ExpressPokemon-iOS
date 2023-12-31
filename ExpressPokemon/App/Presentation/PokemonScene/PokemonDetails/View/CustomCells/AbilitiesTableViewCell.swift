//
//  AbilityTableViewCell.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import UIKit

class AbilitiesTableViewCell: UITableViewCell {
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Labels.abilities
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

    let noAbilitiesLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Labels.abilitiesNotAvailable
        label.font = UIFont.systemFont(ofSize: AppSizes.textMedium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let abilityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = AppSizes.paddingSmall
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        bodyStackView.addArrangedSubview(abilityStackView)
        bodyStackView.addArrangedSubview(noAbilitiesLabel)
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

    // MARK: - Configure Abilities
    func configureAbilities(_ abilities: [String]) {
        // Clear previous ability labels
        for subview in abilityStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }

        if abilities.isEmpty {
            noAbilitiesLabel.isHidden = false
            abilityStackView.isHidden = true
        } else {
            noAbilitiesLabel.isHidden = true
            abilityStackView.isHidden = false
            for ability in abilities {
                let abilityLabel = AbilityView()
                abilityLabel.abilityLabel.text = ability
                abilityStackView.addArrangedSubview(abilityLabel)
            }
        }
    }

    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset the UI elements to their default state
        for subview in abilityStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }

        noAbilitiesLabel.isHidden = true
        abilityStackView.isHidden = false
    }
}
