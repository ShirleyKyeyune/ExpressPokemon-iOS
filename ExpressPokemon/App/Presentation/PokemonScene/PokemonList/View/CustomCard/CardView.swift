//
//  CardView.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import UIKit


class CardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }

    private func  initialSetup() {
        layer.cornerRadius = 10.0
        layer.masksToBounds = false // Note: If you're using shadows, you should set this to false.

        // Shadow settings
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4.0
    }
}
