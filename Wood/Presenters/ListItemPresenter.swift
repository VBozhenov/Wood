//
//  ListItemPresenter.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 01.02.2022.
//

import UIKit

protocol ListItemPresenter: UITableViewDelegate, UITableViewDataSource {
    var listItemViewController: ListItemViewController? { get set }
    
    func viewIsReady()
    func refresh()
}
