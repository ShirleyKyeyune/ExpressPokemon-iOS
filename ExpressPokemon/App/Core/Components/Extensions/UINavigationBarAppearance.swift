//
//  UINavigationBarAppearance.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import Foundation
import UIKit

extension UINavigationBarAppearance {
    static var defaultAppearance: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = AppStyle.Colors.mercury
        appearance.shadowImage = nil
        if let backWhite = UIImage(named: "backWhite") {
            appearance.setBackIndicatorImage(backWhite, transitionMaskImage: backWhite)
        }
        appearance.titleTextAttributes = [
            .foregroundColor: AppStyle.Colors.black,
            .font: AppStyle.Fonts.semibold(size: 17) as Any
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: AppStyle.Colors.black,
            .font: AppStyle.Fonts.bold(size: 36) as Any
        ]
        // NOTE: Hides back button text
        appearance.backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear
        ]

        return appearance
    }
}
