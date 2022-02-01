//
//  MainPresenter.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 26.01.2022.
//

import UIKit

class MainPresenter {
    weak var mainViewController: MainViewController?
    
    func startButtonPressed() {
        guard let mainViewController = mainViewController else { return }
        mainViewController.delegate?.mainViewControllerDidPressStart(mainViewController)
    }
}
