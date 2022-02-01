//
//  Router.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 26.01.2022.
//

import UIKit

protocol Router: AnyObject {
    func present(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?)
    func pop(animated: Bool)
    func dismiss(animated: Bool)
}

extension Router {
    func present(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, onDismissed: nil)
    }
}
