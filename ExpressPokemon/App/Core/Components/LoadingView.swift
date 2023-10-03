//
//  LoadingView.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 03/10/2023.
//

import UIKit

class LoadingView: UIView {
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = UISize.pt32
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var loadingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Constants.AppState.loading
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: UISize.pt16)
        return label
    }()

    private let activityIndicator = UIActivityIndicatorView()

    init() {
        super.init(frame: .zero)

        isUserInteractionEnabled = false
        activityIndicator.startAnimating()

        mainStackView.addArrangedSubview(activityIndicator)
        mainStackView.addArrangedSubview(loadingLabel)

        addSubview(mainStackView)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private functions

    private func setupConstraints() {
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: UISize.pt4).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UISize.pt20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UISize.pt20).isActive = true
    }
}
