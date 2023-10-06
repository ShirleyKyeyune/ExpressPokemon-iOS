//
//  DetailTableViewCell.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    let heightLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Labels.height
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let heightValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let weightLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Labels.weight
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let weightValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.purple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let typesLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Labels.types
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    let typesValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
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
        let heightSpacerView = UIView()
        let weightSpacerView = UIView()
        let typeSpacerView = UIView()
        let heightStackView = UIStackView(arrangedSubviews: [heightLabel, heightSpacerView, heightValueLabel])
        let weightStackView = UIStackView(arrangedSubviews: [weightLabel, weightSpacerView, weightValueLabel])
        let typesStackView = UIStackView(arrangedSubviews: [typesLabel, typeSpacerView, typesValueLabel])

        heightStackView.distribution = .fill
        weightStackView.distribution = .fill
        typesStackView.distribution = .fill
        let mainStackView = UIStackView(arrangedSubviews: [heightStackView, weightStackView, typesStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = AppSizes.paddingMini
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            heightSpacerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            weightSpacerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            typeSpacerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),

            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppSizes.textMedium),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppSizes.textMedium),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppSizes.textMedium),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppSizes.textMedium)
        ])
    }

    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset the UI elements to their default state
        heightValueLabel.text = nil
        weightValueLabel.text = nil
        typesValueLabel.text = nil
    }
}
