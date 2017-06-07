//
//  Board.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct Board {
    let id: Int
    let url: String
    let name: String
}

extension Board: Mappable {
    struct Keys {
        static let id = "id"
        static let url = "self"
        static let name = "name"
    }

    init(map: Mapper) throws {
        try id = map.from(Keys.id)
        try url = map.from(Keys.url)
        try name = map.from(Keys.name)
    }
}
