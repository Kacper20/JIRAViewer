//
//  SprintIssuesContainer.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct KanbanColumn: Decodable, Hashable {
    let name: String

    var hashValue: Int {
        //TODO: Ugly hack, something
        return name.lowercased().hashValue
    }

    static func == (lhs: KanbanColumn, rhs: KanbanColumn) -> Bool {
        return lhs.name.lowercased() == rhs.name.lowercased()
    }
}

struct SprintElementData {
    let title: String
    let labels: String
    let key: String
    let avatarUrl: String?

    init(issue: Issue) {
        self.title = issue.summary
        self.key = issue.key
        self.labels = issue.labels.joined(separator: ",")
        self.avatarUrl = issue.assignee?.avatarUrl
    }
}

struct SprintIssuesContainer {
    private let columns: [KanbanColumn]

    init(columns: [KanbanColumn]) {
        self.columns = columns
    }

    var data: [KanbanColumn : [Issue]] = [:]

    mutating func update(with issues: [Issue]) {
        let keysCount = data.keys.count
        data = [:]
        data.reserveCapacity(keysCount)
        for column in columns {
            data[column] = []
        }

        for issue in issues {
            let column = KanbanColumn(name: issue.status.name)
            if let existingIssues = data[column] {
                data[column] = existingIssues + [issue]
            } else {
                fatalError("Unexpected path")
            }
        }
        print("X")
    }

    func viewModel(at indexPath: IndexPath) -> SprintElementData? {
        let issue = data[columns[indexPath.section]]?[indexPath.item]
        return issue.map(SprintElementData.init)
    }

    private mutating func removeIssue(from path: IndexPath) -> Issue? {
        let column = columns[path.section]
        var array = data[column]
        let issue = array?.remove(at: path.item)
        data[column] = array
        return issue
    }

    //TODO: Error handling to methods
    private mutating func insert(_ issues: [Issue], at path: IndexPath) {
        let column = columns[path.section]
        var array = data[column]
        guard array != nil && (array?.count ?? -1) >= path.item else { return }
        array?.insert(contentsOf: issues, at: path.item)
        data[column] = array
    }

    mutating func moveIssues(from set: Set<IndexPath>, to path: IndexPath) {
        var issues = [Issue]()
        for path in set {
            if let issue = removeIssue(from: path) {
                issues.append(issue)
            }
        }
        insert(issues, at: path)
    }

    func numbersOfSections() -> Int {
        return data.keys.count
    }

    func numbersOfItems(inSection section: Int) -> Int {
        return data[columns[section]]?.count ?? 0
    }
}
