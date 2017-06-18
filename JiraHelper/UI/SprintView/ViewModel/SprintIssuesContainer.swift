//
//  SprintIssuesContainer.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct KanbanColumn: Decodable, Hashable, Comparable {
    let name: String

    var hashValue: Int {
        return name.hashValue
    }

    static func == (lhs: KanbanColumn, rhs: KanbanColumn) -> Bool {
        return lhs.name == rhs.name
    }

    static func < (lhs: KanbanColumn, rhs: KanbanColumn) -> Bool {
        return lhs.name < rhs.name
    }
}

struct SprintIssuesContainer {

    var data: [KanbanColumn : [Issue]] = [:]

    mutating func update(with issues: [Issue]) {
        let keysCount = data.keys.count
        data = [:]
        data.reserveCapacity(keysCount)

        for issue in issues {
            let column = KanbanColumn(name: issue.status.name)
            if let existingIssues = data[column] {
                data[column] = existingIssues + [issue]
            } else {
                data[column] = [issue]
            }
        }
    }

    func numbersOfSections() -> Int {
        return data.keys.count
    }

    func numbersOfItems(inSection section: Int) -> Int {
        let keysSorted = Array(data.keys).sorted()
        return data[keysSorted[section]]?.count ?? 0
    }
}
