//
//  MagazinesPresenter.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 24.01.2022.
//

import UIKit
import RxSwift
import RxCocoa

class MagazinesPresenter: NSObject, ListItemPresenter {
    private let disposeBag = DisposeBag()
    private let urlString = "http://127.0.0.1:8080/api/magazines/"
    private let magazines = BehaviorRelay<[Magazine]>(value: [])
    weak var listItemViewController: ListItemViewController?
    
//    override init() {
//        super.init()
//
//    }
    
    func refresh() {
        magazines.accept([])
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            let urlString = self.urlString.appending("all/")
            self.fetchEvents(urlString: urlString)
        }
    }
    
    func viewIsReady() {
        listItemViewController?.title = "Magazines"
        
        listItemViewController?.addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.addButtonPressed()
            })
            .disposed(by: disposeBag)
        
        magazines
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.listItemViewController?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func addButtonPressed() {
        print("add")
//        guard let magazinesViewController = magazinesViewController else { return }
//        magazinesViewController.delegate?.magazinesViewControllerDidPressAdd(magazinesViewController)
    }
    
    private func fetchEvents(urlString: String) {
        WoodAPIService.getEvents(urlString: urlString)
            .catchErrorJustReturn([])
            .bind(to: magazines)
            .disposed(by: disposeBag)
    }
    
    private func deleteEvent(at index: Int) {
        let magazineID = self.magazines.value[index].id
        let urlString = self.urlString.appending(magazineID)
        WoodAPIService.deleteEvent(urlString: urlString)
            .subscribe(onCompleted: { [weak self] in
                guard let self = self else { return }
                var magazines = self.magazines.value
                magazines.remove(at: index)
                self.magazines.accept(magazines)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.listItemViewController?.alert(title: "Error", text: error.localizedDescription)
                        .subscribe()
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: self.disposeBag)
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
            guard let self = self else { return }
            self.deleteEvent(at: indexPath.row)
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
