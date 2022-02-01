//
//  ListViewController.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 01.02.2022.
//

import UIKit

protocol ListViewControllerDelegate: AnyObject {
//    func listViewControllerDidPressAdd(_ viewController: ListViewController)
//    func listViewController<T>(_ viewController: ListViewController, didSelectEdit: T)
//    func listViewController<T>(_ viewController: ListViewController, didSelect item: T)
}

class ListViewController: UIViewController {
    var presenter: ListPresenter?
    var delegate: ListViewControllerDelegate?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    init(presenter: ListPresenter, delegate: ListViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        self.delegate = delegate
        presenter.listViewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        tableView.delegate = presenter
        tableView.dataSource = presenter
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.refresh()
    }
    
    private func configureView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
        
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addMagazine))
    }
    
    @objc private func addMagazine() {
        presenter?.addButtonPressed()
    }
}
