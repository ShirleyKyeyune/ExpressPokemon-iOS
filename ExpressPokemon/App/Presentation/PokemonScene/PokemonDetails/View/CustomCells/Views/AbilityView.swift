//
//  AbilityView.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import UIKit

class AbilityView: UIView {
    let icon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = UISize.pt24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let abilityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UISize.pt16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let iconContainer = UIView()
        iconContainer.addSubview(icon)

        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: UISize.pt24),
            icon.heightAnchor.constraint(equalToConstant: UISize.pt24)
        ])

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(iconContainer)
        stackView.addArrangedSubview(abilityLabel)
        stackView.addArrangedSubview(spacer)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UISize.pt12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UISize.pt12),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UISize.pt12)
        ])

        configureIcon(UIImage(named: "ability_ico"), for: icon)
    }

    func configureIcon(_ image: UIImage?, for imageView: UIImageView) {
        guard let image = image else {
            return
        }

        imageView.image = image.withRenderingMode(.alwaysTemplate)

        // Generate a random color
        let redColor = CGFloat.random(in: 0...1)
        let greenColor = CGFloat.random(in: 0...1)
        let blueColor = CGFloat.random(in: 0...1)

        imageView.tintColor = UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1)
    }
}
