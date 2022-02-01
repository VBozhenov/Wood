//
//  MainCoordinator.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 26.01.2022.
//

import UIKit

class MainCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router
    
    init(router: Router) {
      self.router = router
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let presenter = MainPresenter()
        let viewController = MainViewController(presenter: presenter, delegate: self)
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
 }

// MARK: - MainViewControllerDelegate
extension MainCoordinator: MainViewControllerDelegate {
    func mainViewControllerDidPressStart(_ viewController: MainViewController) {
//        let router = ModalNavigationRouter(parentViewController: viewController)
//        let coordinator = MagazinesCoordinator(router: router)
//        presentChild(coordinator, animated: true)
    }
}
