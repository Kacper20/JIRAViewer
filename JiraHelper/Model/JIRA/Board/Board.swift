//
//  Board.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct Board: Codable {
    let id: Int
    let url: String
    let name: String

    private enum CodingKeys: String, CodingKey {
        case url = "self"
        case name
        case id
    }
}
