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
        stackView.spacing = AppSizes.paddingMedium
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
        label.font = UIFont.systemFont(ofSize: AppSizes.textMedium)
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
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: AppSizes.paddingMicro).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppSizes.paddingSmall).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppSizes.paddingSmall).isActive = true
    }
}
