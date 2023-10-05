//
//  StatProgressView.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import UIKit

class StatProgressView: UIView {
    let progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()

    let percentageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UISize.pt12)
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
        addSubview(progressBar)
        addSubview(percentageLabel)

        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UISize.pt40),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.centerYAnchor.constraint(equalTo: centerYAnchor),

            percentageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor)
        ])
    }

    func setProgress(_ progress: Float) {
        progressBar.progress = progress
        let percentage = Double(progress * 100).roundedTwoDecimalsString
        percentageLabel.text = "\(percentage)%"
    }
}
