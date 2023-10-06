//
//  EmptyView.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import UIKit

class EmptyView: UIView {
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = AppSizes.paddingMedium
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var emptyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "empty_state"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var emptyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Empty State"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init() {
        super.init(frame: .zero)

        horizontalStackView.addArrangedSubview(emptyLabel)

        mainStackView.addArrangedSubview(emptyImageView)
        mainStackView.addArrangedSubview(horizontalStackView)

        addSubview(mainStackView)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private functions

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: AppSizes.paddingMini),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppSizes.paddingSmall),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppSizes.paddingSmall),

            emptyImageView.widthAnchor.constraint(equalToConstant: AppSizes.emptyImageViewWidth),
            emptyImageView.heightAnchor.constraint(equalToConstant: AppSizes.emptyImageViewWidth)
        ])
    }

    func setEmptyLabelText(_ text: String) {
        emptyLabel.text = text
    }

    func setEmptyImage(_ image: UIImage) {
        emptyImageView.image = image
    }
}
