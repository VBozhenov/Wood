//
//  MagazinesPresenter.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 24.01.2022.
//

import UIKit
import RxSwift
import RxCocoa

class MagazinesPresenter: NSObject, ListPresenter {
    private let bag = DisposeBag()
    private let urlString = "http://127.0.0.1:8080/api/magazines/"
    private let magazines = BehaviorRelay<[Magazine]>(value: [])
    weak var listViewController: ListViewController?
    
    override init() {
        super.init()
        magazines
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.listViewController?.tableView.reloadData()
                }
            })
            .disposed(by: bag)
    }
    
    func refresh() {
        listViewController?.title = "Magazines"
        magazines.accept([])
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            let urlString = self.urlString.appending("all/")
            self.fetchEvents(urlString: urlString)
        }
    }
    
    func addButtonPressed() {
//        guard let magazinesViewController = magazinesViewController else { return }
//        magazinesViewController.delegate?.magazinesViewControllerDidPressAdd(magazinesViewController)
    }
    
    private func fetchEvents(urlString: String) {
        NetworkService.getEvents(urlString: urlString)
            .bind(to: magazines)
            .disposed(by: bag)
    }
    
    private func deleteEvent(urlString: String, completion: @escaping (() -> Void)) {
//        NetworkService.deleteEvent(urlString: urlString)
//            .subscribe(onCompleted: {
//                completion()
//            })
//            .disposed(by: self.bag)
    }
}

// MARK: - UITableViewDelegate
extension MagazinesPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let magazinesViewController = magazinesViewController else { return }
//        let magazine = magazines.value[indexPath.row]
//        magazinesViewController.delegate?.magazinesViewController(magazinesViewController, didSelect: magazine)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completionHandler in
//            guard let self = self else { return }
//            let magazineID = self.magazines.value[indexPath.row].id
//            let urlString = self.urlString.appending(magazineID)
//            self.deleteEvent(urlString: urlString) {
//                var magazines = self.magazines.value
//                magazines.remove(at: indexPath.row)
//                self.magazines.accept(magazines)
//                DispatchQueue.main.async {
//                    tableView.deleteRows(at: [indexPath], with: .automatic)
//                }
//            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completionHandler in
//            guard let magazinesViewController = self?.magazinesViewController,
//                  let magazine = self?.magazines.value[indexPath.row] else { return }
//            magazinesViewController.delegate?.magazinesViewController(magazinesViewController, didSelectEdit: magazine)
            completionHandler(true)
        }
        editAction.image = UIImage(systemName: "square.and.pencil")
        editAction.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
}

// MARK: - UITableViewDataSource
extension MagazinesPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        magazines.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let magazine = magazines.value[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = magazine.title
        content.secondaryText = "Issues: \(magazine.issues?.count ?? 0)"
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        return cell
    }
}
