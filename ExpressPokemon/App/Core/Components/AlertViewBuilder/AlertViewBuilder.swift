//
//  AlertViewBuilder.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 04/10/2023.
//

import Foundation
import UIKit

protocol AlertViewBuilderProtocol: AnyObject {
    @discardableResult
    func erase() -> Self

    @discardableResult
    func build(title: String, message: String, preferredStyle: UIAlertController.Style) -> Self

    @discardableResult
    func buildAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> Self

    var content: UIAlertController { get }
}

final class AlertViewBuilder: AlertViewBuilderProtocol {
    private var internalContent = UIAlertController()

    func erase() -> Self {
        internalContent = UIAlertController()
        return self
    }

    func build(title: String, message: String, preferredStyle: UIAlertController.Style) -> Self {
        internalContent = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        return self
    }

    func buildAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        internalContent.addAction(action)
        return self
    }

    var content: UIAlertController {
        internalContent
    }
}
