//
//  Magazine.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 20.01.2022.
//

import Foundation

struct Magazine: Codable {
    let id: String
    let title: String
    let issues: [Issue]
    
    func createMagazine() -> CreateMagazine {
        CreateMagazine(title: title)
    }
}

struct CreateMagazine: Codable {
    let title: String
}
