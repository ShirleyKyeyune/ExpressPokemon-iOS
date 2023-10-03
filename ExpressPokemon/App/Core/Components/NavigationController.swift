//
//  NavigationController.swift
//  ExpressPokemon
//
//  Created by Shirley Kyeyune on 03/10/2023.
//

import UIKit

protocol PushNotifiable {
    func didPushViewController(animated: Bool)
}

@objc protocol PopInteractable {
    func shouldBePopped() -> Bool
}

@objc protocol PopNotifiable {
    @objc optional func willPopViewController(animated: Bool)
    func didPopViewController(animated: Bool)
}

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
    private var isPopActionInteractive = false

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { [viewController] in
                guard let viewController = viewController as? PushNotifiable else {
                    return
                }
                verboseLog("[NavigationController].pushViewController isCancelled: \(false), viewController: \(viewController)")
                viewController.didPushViewController(animated: animated)
            }
            return
        }

        coordinator.animate(alongsideTransition: nil) { context in
            guard !context.isCancelled else {
                return
            }
            guard let viewController = viewController as? PushNotifiable else {
                return
            }
            verboseLog("[NavigationController].pushViewController isCancelled: \(context.isCancelled), viewController: \(viewController)")
            viewController.didPushViewController(animated: animated)
        }
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        let isPopActionInteractive = self.isPopActionInteractive
        self.isPopActionInteractive = false

        let viewController = super.popViewController(animated: animated)

        if let viewController = viewController as? PopNotifiable {
            viewController.willPopViewController?(animated: animated)
        }

        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async {
                guard let viewController = viewController as? PopNotifiable else {
                    return
                }
                verboseLog("[NavigationController].popViewController isCancelled: \(false), viewController: \(viewController)")
                viewController.didPopViewController(animated: animated)
            }

            return viewController
        }

        if isPopActionInteractive {
            coordinator.animate(alongsideTransition: nil) { context in
                guard !context.isCancelled else {
                    return
                }

                guard let viewController = viewController as? PopNotifiable else {
                    return
                }
                // swiftlint:disable line_length
                verboseLog("[NavigationController].popViewController isCancelled: \(context.isCancelled), viewController: \(viewController)")
                viewController.didPopViewController(animated: animated)
            }
        } else {
            if let viewController = viewController as? PopNotifiable {
                verboseLog("[NavigationController].popViewController, viewController: \(viewController)")
                viewController.didPopViewController(animated: animated)
            }

            coordinator.animate(alongsideTransition: nil) { _ in
                // no-op
            }
        }

        return viewController
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        isPopActionInteractive = true

        if let canPreventPop = topViewController as? PopInteractable {
            return !canPreventPop.shouldBePopped()
        }

        return true
    }
}
