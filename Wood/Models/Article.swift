//
//  Article.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 27.01.2022.
//

import Foundation

struct Article: Codable {
    let id: String
    let title: String?
    let page: Int?
    let description: String?
    let issue: Issue?
    
    func createArticle() -> CreateArticle {
        CreateArticle(title: title, page: page, description: description, issueID: issue?.id)
    }
}

struct CreateArticle: Codable {
    let title: String?
    let page: Int?
    let description: String?
    let issueID: String?
}
