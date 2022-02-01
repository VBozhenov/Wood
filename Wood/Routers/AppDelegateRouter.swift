//
//  AppDelegateRouter.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 26.01.2022.
//
import UIKit

class AppDelegateRouter: Router {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    func dismiss(animated: Bool) {}
    func pop(animated: Bool) {}
}
