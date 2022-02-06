//
//  AppDelegateRouter.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 26.01.2022.
//
import UIKit

class AppDelegateRouter: Router {
    let window: UIWindow
    var navigationController: UINavigationController
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        window.rootViewController = navigationController
        navigationController.pushViewController(viewController, animated: animated)
        window.makeKeyAndVisible()
    }
    
    func dismiss(animated: Bool) {}
    func pop(animated: Bool) {}
}
