//
//  PokemonCell.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import Foundation
import UIKit

class PokemonCell: UICollectionViewCell {
    // MARK: - Properties
    let cellContainerView = CardView()
    let cellNameLabel = UILabel()
    let cellImageView = UIImageView()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset the UI elements to their default state
        cellNameLabel.text = nil
        cellImageView.image = nil
        cellContainerView.backgroundColor = nil
    }

    // MARK: - Setup UI
    private func setupUI() {
        addSubview(cellContainerView)
        cellContainerView.addSubview(cellNameLabel)
        cellContainerView.addSubview(cellImageView)

        // Configure cellContainerView
        cellContainerView.translatesAutoresizingMaskIntoConstraints = false
        cellContainerView.backgroundColor = UIColor(white: 0.33, alpha: 1)

        // Configure cellNameLabel
        cellNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cellNameLabel.text = ""
        cellNameLabel.textAlignment = .center
        cellNameLabel.textColor = .white
        cellNameLabel.font = UIFont.boldSystemFont(ofSize: AppSizes.textMedium)

        // Configure cellImageView
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.contentMode = .scaleAspectFit
        // Set image for cellImageView if any

        // Apply Constraints
        NSLayoutConstraint.activate([
            // Constraints for cellContainerView
            cellContainerView.topAnchor.constraint(equalTo: topAnchor),
            cellContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // Constraints for cellImageView
            cellImageView.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: AppSizes.textMedium),
            cellImageView.centerXAnchor.constraint(equalTo: cellContainerView.centerXAnchor),
            cellImageView.widthAnchor.constraint(equalToConstant: AppSizes.cellImageViewHeight),
            cellImageView.heightAnchor.constraint(equalToConstant: AppSizes.cellImageViewHeight),

            // Constraints for cellNameLabel
            cellNameLabel.topAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: AppSizes.cellNameLabelHeight),
            cellNameLabel.centerXAnchor.constraint(equalTo: cellContainerView.centerXAnchor),
            cellNameLabel.heightAnchor.constraint(equalToConstant: AppSizes.cellNameLabelHeight)
        ])
    }

    func configureImageBgColor(loadedImage: UIImage?) {
        cellImageView.image = loadedImage
        DispatchQueue.main.async {
            if let imageColor = loadedImage?.averageColor {
                self.cellContainerView.backgroundColor = imageColor
            }
        }
    }
}
