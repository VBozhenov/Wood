//
//  Model.swift
//  Wood
//
//  Created by Vladimir Bozhenov on 01.02.2022.
//

import Foundation

protocol Model: Codable {
    var id: String { get set }
    var title: String { get set }
    var year: Int? { get set }
    var page: Int? { get set }
    var description: String? { get set }
    var children: [Codable]? { get set }
}
