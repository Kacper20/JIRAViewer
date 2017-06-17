//
//  SprintIssuesContainer.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct KanbanStage: Hashable {
    let name: String

    var hashValue: Int {
        return name.hashValue
    }

    static func == (lhs: KanbanStage, rhs: KanbanStage) -> Bool {
        return lhs.name == rhs.name
    }
}

struct SprintIssuesContainer {

    var data: [KanbanStage : Issue] = [:]

    mutating func update(with issues: [Issue]) {
        let keysCount = data.keys.count
        data = [:]
        data.reserveCapacity(keysCount)
    }

}
