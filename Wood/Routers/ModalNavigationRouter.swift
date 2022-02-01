//
//  ModalNavigationRouter.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 27.01.2022.
//

import UIKit

class ModalNavigationRouter: NSObject {
    // MARK: - Instance Properties
    unowned let parentViewController: UIViewController
    
    private let navigationController = UINavigationController()
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
    
    // MARK: - Object Lifecycle
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        super.init()
        navigationController.delegate = self
    }
}

// MARK: - Router
extension ModalNavigationRouter: Router {
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        onDismissForViewController[viewController] = onDismissed
        if navigationController.viewControllers.isEmpty {
            presentModally(viewController, animated: animated)
        } else {
            navigationController.pushViewController(viewController, animated: animated)
        }
    }
    
    func pop(animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.popViewController(animated: animated)
        }
    }
    
    private func presentModally(_ viewController: UIViewController, animated: Bool) {
        addCancelButton(to: viewController)
        navigationController.setViewControllers([viewController], animated: false)
        parentViewController.present(navigationController, animated: animated, completion: nil)
    }
    
    private func addCancelButton(to viewController: UIViewController) {
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelPressed)
        )
    }
    
    @objc private func cancelPressed() {
        guard let viewController = navigationController.viewControllers.first else { return }
        performOnDismissed(for: viewController)
        dismiss(animated: true)
    }
    
    func dismiss(animated: Bool) {
        guard let viewController = navigationController.viewControllers.first else { return }
        performOnDismissed(for: viewController)
        parentViewController.dismiss(animated: animated, completion: nil)
    }
    
    private func performOnDismissed(for viewController: UIViewController) {
        guard let onDismiss = onDismissForViewController[viewController] else { return }
        onDismiss()
        onDismissForViewController[viewController] = nil
    }
}

// MARK: - UINavigationControllerDelegate
extension ModalNavigationRouter: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(dismissedViewController) else { return }
        performOnDismissed(for: dismissedViewController)
    }
}
