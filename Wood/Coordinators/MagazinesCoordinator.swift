//
//  MagazinesCoordinator.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 27.01.2022.
//

import Foundation

class MagazinesCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router
    
    init(router: Router) {
      self.router = router
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let presenter = MagazinesPresenter()
        let viewController = ListItemViewController(presenter: presenter, delegate: self)
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

// MARK: - ListItemViewControllerDelegate
extension MagazinesCoordinator: ListItemViewControllerDelegate {
    func listViewController<T>(_ viewController: ListItemViewController, didSelect item: T) {
        //        guard let item = item as? Magazine else { return }
        let presenter: ListItemPresenter
        switch item.self {
        case is Magazine:
            guard let item = item as? Magazine else { return }
            presenter = IssuesPresenter(magazine: item)
        case is Issue:
            guard let item = item as? Issue else { return }
            presenter = ArticlesPresenter(issue: item)
        default: return
            //        let presenter = IssuesPresenter(magazine: item)
        }
        let viewController = ListItemViewController(presenter: presenter, delegate: self)
        router.present(viewController, animated: true)
    }
    
//    func magazinesViewControllerDidPressAdd(_ viewController: MagazinesViewController) {
//        let presenter = AddMagazinePresenter()
//        let viewController = AddMagazineViewController(presenter: presenter, delegate: self)
//        router.present(viewController, animated: true)
//    }
    
//    func magazinesViewController(_ viewController: MagazinesViewController, didSelectEdit magazine: Magazine) {
//        let presenter = EditMagazinePresenter(magazine: magazine)
//        let viewController = EditMagazineViewController(presenter: presenter, delegate: self)
//        router.present(viewController, animated: true)
//    }
    
//    func magazinesViewController(_ viewController: MagazinesViewController, didSelect magazine: Magazine) {
//        let presenter = IssuesPresenter(magazineID: magazine.id)
//        let viewController = IssuesViewController(presenter: presenter, delegate: self)
//        router.present(viewController, animated: true)
//    }
}
//
//// MARK: - AddMagazineViewControllerViewControllerDelegate
//extension MagazinesCoordinator: AddMagazineViewControllerDelegate {
//    func addMagazineViewControllerDidPressSave(_ viewController: AddMagazineViewController) {
//        router.pop(animated: true)
//    }
//
//    func addMagazineViewControllerDidPressCancel(_ viewController: AddMagazineViewController) {
//        router.pop(animated: true)
//    }
//}
//
//// MARK: - EditMagazineViewControllerViewControllerDelegate
//extension MagazinesCoordinator: EditMagazineViewControllerDelegate {
//    func editMagazineViewControllerDidPressSave(_ viewController: EditMagazineViewController) {
//        router.pop(animated: true)
//    }
//
//    func editMagazineViewControllerDidPressCancel(_ viewController: EditMagazineViewController) {
//        router.pop(animated: true)
//    }
//}
//
//// MARK: - IssuesViewControllerDelegate
//extension MagazinesCoordinator: IssuesViewControllerDelegate {
//    func issuesViewControllerDidPressAdd(_ viewController: IssuesViewController, with magazineID: String) {
//        let presenter = AddIssuePresenter(issuesMagazineID: magazineID)
//        let viewController = AddIssueViewController(presenter: presenter, delegate: self)
//        router.present(viewController, animated: true)
//    }
//
//    func issuesViewController(_ viewController: IssuesViewController, didSelectEdit issue: Issue, with magazineID: String) {
//        let presenter = EditIssuePresenter(issue: issue, issuesMagazineID: magazineID)
//        let viewController = EditIssueViewController(presenter: presenter, delegate: self)
//        router.present(viewController, animated: true)
//    }
//
//    func issuesViewController(_ viewController: IssuesViewController, didSelect issue: Issue) {
//        let presenter = ArticlesPresenter(issueID: issue.id)
//        let viewController = ArticlesViewController(presenter: presenter, delegate: self)
//        router.present(viewController, animated: true)
//    }
//}
//
//// MARK: - AddIssueViewControllerDelegate
//extension MagazinesCoordinator: AddIssueViewControllerDelegate {
//    func addIssueViewControllerDidPressSave(_ viewController: AddIssueViewController) {
//        router.pop(animated: true)
//    }
//
//    func addIssueViewControllerDidPressCancel(_ viewController: AddIssueViewController) {
//        router.pop(animated: true)
//    }
//}
//
//// MARK: - EditIssueViewControllerDelegate
//extension MagazinesCoordinator: EditIssueViewControllerDelegate {
//    func editIssueViewControllerDidPressSave(_ viewController: EditIssueViewController) {
//        router.pop(animated: true)
//    }
//
//    func editIssueViewControllerDidPressCancel(_ viewController: EditIssueViewController) {
//        router.pop(animated: true)
//    }
//}
//
//// MARK: - ArticlesViewControllerDelegate
//extension MagazinesCoordinator: ArticlesViewControllerDelegate {
//    func articlesViewControllerDidPressAdd(_ viewController: ArticlesViewController, with issueID: String) {
//        let presenter = AddArticlePresenter(articlesIssueID: issueID)
//        let viewController = AddArticleViewController(presenter: presenter, delegate: self)
//        router.present(viewController, animated: true)
//    }
//
//    func articlesViewController(_ viewController: ArticlesViewController, didSelectEdit article: Article, with issueID: String) {
//        let presenter = EditArticlePresenter(article: article, articlesIssueID: issueID)
//        let viewController = EditArticleViewController(presenter: presenter, delegate: self)
//        router.present(viewController, animated: true)
//    }
//}
//
//// MARK: - AddArticleViewControllerDelegate
//extension MagazinesCoordinator: AddArticleViewControllerDelegate {
//    func addArticleViewControllerDidPressSave(_ viewController: AddArticleViewController) {
//        router.pop(animated: true)
//    }
//
//    func addArticleViewControllerDidPressCancel(_ viewController: AddArticleViewController) {
//        router.pop(animated: true)
//    }
//}
//
//// MARK: - EditArticleViewControllerDelegate
//extension MagazinesCoordinator: EditArticleViewControllerDelegate {
//    func editArticleViewControllerDidPressSave(_ viewController: EditArticleViewController) {
//        router.pop(animated: true)
//    }
//
//    func editArticleViewControllerDidPressCancel(_ viewController: EditArticleViewController) {
//        router.pop(animated: true)
//    }
//}
