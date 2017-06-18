//
//  BoardConfiguration.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 18/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct BoardConfiguration: Decodable {
    let columns: [KanbanColumn]

    private enum CodingKeys: String, CodingKey {
        case columnConfig
        case columns
    }

    init(from: Decoder) throws {
        let container = try from.container(keyedBy: CodingKeys.self)
        let columnDict = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .columnConfig)
        columns = try columnDict.decode([KanbanColumn].self, forKey: .columns)
    }
}
