//
//  ListItemViewController.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 01.02.2022.
//

import UIKit

protocol ListItemViewControllerDelegate: AnyObject {
//    func listViewControllerDidPressAdd(_ viewController: ListViewController)
//    func listViewController<T>(_ viewController: ListViewController, didSelectForEdit item: T)
//    func listViewController<T>(_ viewController: ListViewController, didSelect item: T)
}

class ListItemViewController: UIViewController {
    var presenter: ListItemPresenter?
    var delegate: ListItemViewControllerDelegate?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
        return tableView
    }()
    
    let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .add)
        return button
    }()
    
    init(presenter: ListItemPresenter, delegate: ListItemViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        self.delegate = delegate
        self.presenter?.listItemViewController = self
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewIsReady()
    }
    
    private func configureView() {
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
