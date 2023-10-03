//
//  AppStyle.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 03/10/2023.
//

import Foundation
import UIKit

enum AppStyle {
    static func applyStyle() {
        UIWindow.appearance().tintColor = Colors.appTint

        UINavigationBar.appearance().shadowImage = UIImage(color: Colors.mercury, size: CGSize(width: 0.25, height: 0.25))
        UINavigationBar.appearance().compactAppearance = UINavigationBarAppearance.defaultAppearance
        UINavigationBar.appearance().standardAppearance = UINavigationBarAppearance.defaultAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance.defaultAppearance

        // We could have set the backBarButtonItem with an empty title for every view controller. Using appearance here, while a hack is still more convenient though, since we don't have to do it for every view controller instance
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for: .default)
        UIBarButtonItem.appearance().tintColor = Colors.mine
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIToolbar.self]).tintColor = Colors.mine

        UIToolbar.appearance().tintColor = Colors.appTint

        // Background (not needed in iOS 12.1 on simulator)
        // Cancel button
        UISearchBar.appearance().tintColor = Colors.mine
        // Cursor color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = Colors.mine

        UIRefreshControl.appearance().tintColor = .black

        UISwitch.appearance().onTintColor = Colors.appTint

        UITableView.appearance().separatorColor = Colors.mercury
    }

    enum Colors {
        static let appText = UIColor.black
        static let appTint = UIColor(hexString: "007FFF")
        static let appWhite = UIColor.white
        static let black = UIColor(hexString: "313849")
        static let darkGray = UIColor(hexString: "2f2f2f")
        static let darkBlue = UIColor(hexString: "3375BB")
        static let mercury = UIColor(hexString: "E9E9E9")
        static let mine = UIColor(hexString: "2F2F2F")
    }

    enum Fonts {
        static func regular(size: CGFloat) -> UIFont {
            .systemFont(ofSize: size, weight: .regular)
    //        guard let customFont = UIFont(name: "PokemonSolidNormal-xyWR", size: size) else {
    //            fatalError("""
    //                    Failed to load the "PokemonSolidNormal" font.
    //                    Make sure the font file is included in the project and the font name is spelled correctly.
    //                    """
    //            )
    //        }
    //        return customFont
        }
        static func semibold(size: CGFloat) -> UIFont {
            .systemFont(ofSize: size, weight: .semibold)
    //        guard let customFont = UIFont(name: "Pokemon Hollow", size: size) else {
    //            fatalError("""
    //                    Failed to load the "PokemonHollow" font.
    //                    Make sure the font file is included in the project and the font name is spelled correctly.
    //                    """
    //            )
    //        }
    //        return customFont
        }
        static func bold(size: CGFloat) -> UIFont {
            .systemFont(ofSize: size, weight: .bold)
    //        guard let customFont = UIFont(name: "PokemonSolidNormal-xyWR", size: size) else {
    //            fatalError("""
    //                    Failed to load the "PokemonSolidNormal" font.
    //                    Make sure the font file is included in the project and the font name is spelled correctly.
    //                    """
    //            )
    //        }
    //        return customFont
        }
    }

    enum Style {
        enum Animation {
            static let duration = 0.5
            static let curve: UIView.AnimationCurve = .easeInOut
        }
    }
}
