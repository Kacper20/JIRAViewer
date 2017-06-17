//
//  BoardConfiguration.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 18/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct BoardConfiguration {
    let columns: [KanbanColumn]

    private enum CodingKeys: String, CodingKey {
        case columnConfig
        case columns
    }

    
}
