//
//  CustomError.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 02/10/2023.
//

import Foundation

protocol CustomErrorType: LocalizedError {
    var title: String? { get }
    var code: Int { get }
}

struct CustomError: CustomErrorType {
    var title: String?
    var code: Int
    var errorDescription: String? { _description }
    var failureReason: String? { _description }

    private var _description: String

    init(description: String, code: Int, title: String = "Error") {
        self.title = title
        self._description = description
        self.code = code
    }
}
