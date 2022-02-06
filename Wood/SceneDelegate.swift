//
//  SceneDelegate.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 01.02.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        guard let window = window else { return }
        let navigationController = UINavigationController()
        let router = AppDelegateRouter(window: window, navigationController: navigationController)
        let coordinator = MainCoordinator(router: router)
        coordinator.present(animated: true, onDismissed: nil)
    }
}
