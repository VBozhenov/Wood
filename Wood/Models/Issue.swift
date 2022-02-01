//
//  Issue.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 21.01.2022.
//

import Foundation

struct Issue: Codable {
    let id: String
    let title: String
    let year: Int
    let magazine: Magazine
    let articles: [Article]?
    
    func createIssue() -> CreateIssue {
        CreateIssue(title: title, year: year, magazineID: magazine.id)
    }
}

struct CreateIssue: Codable {
    let title: String
    let year: Int
    let magazineID: String
}
