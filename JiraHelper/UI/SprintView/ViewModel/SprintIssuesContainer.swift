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
    let assigneeAvatarUrl: String?
    let typeAvatarUrl: String
    let priorityAvatarUrl: String

    init(issue: BasicIssue) {
        self.title = issue.summary
        self.key = issue.key
        self.labels = issue.labels.joined(separator: ",")
        self.assigneeAvatarUrl = issue.assignee?.avatarUrl
        self.typeAvatarUrl = issue.type.iconUrl
        self.priorityAvatarUrl = issue.priority.pngIconUrl
    }
}

typealias IssuesStorage = [KanbanColumn : [BasicIssue]]

struct FilteredData {
    private var filter: (BasicIssue) -> Bool
    private(set) var data: IssuesStorage = [:]

    init(baseData: IssuesStorage, filter: @escaping (BasicIssue) -> Bool) {
        data = baseData
        self.filter = filter
        data = applyFiltering(baseData: baseData, filter: filter)
    }

    private func applyFiltering(baseData: IssuesStorage, filter: @escaping (BasicIssue) -> Bool) -> IssuesStorage {
        return baseData.mapValues { (array: [BasicIssue]) -> [BasicIssue] in
            return array.filter(filter)
        }
    }

    mutating func apply(filter: @escaping (BasicIssue) -> Bool, on baseData: IssuesStorage) {
        self.data = applyFiltering(baseData: baseData, filter: filter)
    }

    mutating func setBaseData(baseData: IssuesStorage) {
        self.data = applyFiltering(baseData: data, filter: filter)
    }
}

struct SprintIssuesContainer {
    private let columns: [KanbanColumn]

    private var filteredData: FilteredData
    private var baseData: IssuesStorage = [:]

    init(columns: [KanbanColumn]) {
        self.columns = columns
        filteredData = FilteredData(baseData: [:], filter: { _ in true })
    }

    mutating func update(with issues: [BasicIssue]) {
        let keysCount = baseData.keys.count
        baseData = [:]
        baseData.reserveCapacity(keysCount)
        for column in columns {
            baseData[column] = []
        }

        for issue in issues {
            let column = KanbanColumn(name: issue.status.name)
            if let existingIssues = baseData[column] {
                baseData[column] = existingIssues + [issue]
            } else {
                fatalError("Unexpected path")
            }
        }
        filteredData.setBaseData(baseData: baseData)
    }

    func issue(at indexPath: IndexPath) -> BasicIssue? {
        return filteredData.data[columns[indexPath.section]]?[indexPath.item]
    }

    func viewModel(at indexPath: IndexPath) -> SprintElementData? {
        return issue(at: indexPath).map(SprintElementData.init)
    }

    mutating func updateIssueAndGetPath(newIssue: BasicIssue) -> IndexPath? {
        let column = KanbanColumn(name: newIssue.status.name)
        if let columnIndex = columns.index(of: column),
           var issues = baseData[column],
           let index = issues.index(where: { $0.id == newIssue.id }) {
            issues[index] = newIssue
            baseData[column] = issues
            return IndexPath(item: index, section: columnIndex)
        } else {
            return nil
        }
    }

    private mutating func removeIssue(from path: IndexPath) -> BasicIssue? {
        let column = columns[path.section]
        var array = baseData[column]
        let issue = array?.remove(at: path.item)
        baseData[column] = array
        return issue
    }

    //TODO: Error handling to methods
    private mutating func insert(_ issues: [BasicIssue], at path: IndexPath) {
        let column = columns[path.section]
        var array = baseData[column]
        guard array != nil && (array?.count ?? -1) >= path.item else { return }
        array?.insert(contentsOf: issues, at: path.item)
        baseData[column] = array
    }

    mutating func apply(filter: @escaping (BasicIssue) -> Bool) {
        filteredData.apply(filter: filter, on: baseData)
    }

    mutating func moveIssues(from set: Set<IndexPath>, to path: IndexPath) {
        var issues = [BasicIssue]()
        for path in set {
            if let issue = removeIssue(from: path) {
                issues.append(issue)
            }
        }
        insert(issues, at: path)
    }

    func numbersOfSections() -> Int {
        return filteredData.data.keys.count
    }

    func numbersOfItems(inSection section: Int) -> Int {
        return filteredData.data[columns[section]]?.count ?? 0
    }
}
