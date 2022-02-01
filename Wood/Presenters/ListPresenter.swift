//
//  ListPresenter.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 01.02.2022.
//

import UIKit

protocol ListPresenter: UITableViewDelegate, UITableViewDataSource {
    var listViewController: ListViewController? { get set }

    func refresh()
    func addButtonPressed()
}
