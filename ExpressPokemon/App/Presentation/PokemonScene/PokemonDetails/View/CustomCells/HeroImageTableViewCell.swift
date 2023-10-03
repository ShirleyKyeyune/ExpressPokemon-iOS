//
//  HeroImageTableViewCell.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import UIKit

protocol HeroImageTableViewCellDelegate: AnyObject {
    func viewDidLoadImage(imageColor: UIColor, in tableViewCell: HeroImageTableViewCell)
}

class HeroImageTableViewCell: UITableViewCell {
    let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()

    let translucentBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()

    weak var delegate: HeroImageTableViewCellDelegate?

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
        contentView.addSubview(heroImageView)
        heroImageView.addSubview(translucentBackgroundView)
        translucentBackgroundView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            translucentBackgroundView.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor),
            translucentBackgroundView.trailingAnchor.constraint(equalTo: heroImageView.trailingAnchor),
            translucentBackgroundView.bottomAnchor.constraint(equalTo: heroImageView.bottomAnchor),
            translucentBackgroundView.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.leadingAnchor.constraint(equalTo: translucentBackgroundView.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: translucentBackgroundView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset the UI elements to their default state
        heroImageView.image = nil
        titleLabel.text = nil
    }

    func configureImageBgColor(loadedImage: UIImage?) {
        heroImageView.image = loadedImage
        DispatchQueue.main.async {
            if let imageColor = loadedImage?.averageColor {
                self.contentView.backgroundColor = imageColor
                self.delegate?.viewDidLoadImage(imageColor: imageColor, in: self)
            }
        }
    }
}
