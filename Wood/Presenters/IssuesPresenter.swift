//
//  IssuesPresenter.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 07.02.2022.
//

import UIKit
import RxSwift
import RxCocoa

class IssuesPresenter: NSObject, ListItemPresenter {
    let magazine: Magazine
    private let disposeBag = DisposeBag()
    private let urlString = "http://127.0.0.1:8080/api/issues/"
    private let issues = BehaviorRelay<[Issue]>(value: [])
    weak var listItemViewController: ListItemViewController?
    
    init(magazine: Magazine) {
        self.magazine = magazine
    }
    
    func refresh() {
        issues.accept([])
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            let urlString = self.urlString.appending("\(self.magazine.id)/")
            self.fetchEvents(urlString: urlString)
        }
    }
    
    func viewIsReady() {
        listItemViewController?.title = "\(self.magazine.title ?? "Unknown magazine")"
        
        listItemViewController?.addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.addButtonPressed()
            })
            .disposed(by: disposeBag)
        
        issues
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
            .bind(to: issues)
            .disposed(by: disposeBag)
    }
    
//    private func deleteEvent(at index: Int) {
//        let issueID = self.issues.value[index].id
//        let urlString = self.urlString.appending(issueID)
//        WoodAPIService.deleteEvent(urlString: urlString)
//            .subscribe(onCompleted: { [weak self] in
//                guard let self = self else { return }
//                var issues = self.issues.value
//                issues.remove(at: index)
//                self.issues.accept(issues)
//            }, onError: { [weak self] error in
//                guard let self = self else { return }
//                DispatchQueue.main.async {
//                    self.listItemViewController?.alert(title: "Error", text: error.localizedDescription)
//                        .subscribe()
//                        .disposed(by: self.disposeBag)
//                }
//            })
//            .disposed(by: self.disposeBag)
//    }
}

// MARK: - UITableViewDelegate
extension IssuesPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let issue = issues.value[indexPath.row]
        guard let listItemViewController = listItemViewController else { return }
        listItemViewController.delegate?.listViewController(listItemViewController, didSelect: issue)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completionHandler in
            guard let self = self else { return }
//            self.deleteEvent(at: indexPath.row)
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
extension IssuesPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        issues.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let issue = issues.value[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = issue.title
        content.secondaryText = "Articles: \(issue.articles?.count ?? 0)"
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        return cell
    }
}
