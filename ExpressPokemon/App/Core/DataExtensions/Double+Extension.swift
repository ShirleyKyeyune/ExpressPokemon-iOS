//
//  NumberFormatter+Extension.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 05/10/2023.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    var twoDecimalPlaces: String {
        String(format: "%.2f", self)
    }

    var roundedTwoDecimalsString: String {
        "\(rounded(toPlaces: 2))"
    }
}
