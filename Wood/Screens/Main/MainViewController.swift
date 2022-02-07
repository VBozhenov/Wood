//
//  MainViewController.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 26.01.2022.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func mainViewControllerDidPressStart(_ viewController: MainViewController)
}

class MainViewController: UIViewController {
    var presenter: MainPresenter?
    var delegate: MainViewControllerDelegate?
    
    let startButton = UIButton()
    
    init(presenter: MainPresenter, delegate: MainViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        self.delegate = delegate
        presenter.mainViewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        configureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewIsReady()
    }
    
    private func configureView() {
        view.backgroundColor = UIColor(hexValue: "#966F33", alpha: 1)

        view.addSubview(startButton)
        startButton.backgroundColor = UIColor(hexValue: "#335B96", alpha: 1)
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(UIColor(hexValue: "#966F33", alpha: 1), for: .normal)
        startButton.layer.cornerRadius = 16
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 32),
            startButton.widthAnchor.constraint(equalToConstant: 128)
        ])
    }
}
