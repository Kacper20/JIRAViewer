//
//  SprintIssuesEndpoints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum IssuesEndpoints {
    static func all(forSprint sprint: ActiveSprint) -> EndpointConfiguration<ArrayOfValuesWithPagingData<Issue>> {
        return EndpointConfiguration(
            path: "/agile/latest/board/\(sprint.setupData.originBoardId)/sprint/\(sprint.id)/issue",
            method: .get,
            encoding: URLEncoding.default,
            headers: [:],//TODO: Temporary labels
            parameters: ["jql" : "labels = iOS"],
            resourceType: .json
        )
    }

    static func issue(withId id: String) -> EndpointConfiguration<Issue> {
        return EndpointConfiguration(
            path: "/api/latest/issue/\(id)",
            method: .get,
            encoding: URLEncoding.default,
            headers: [:],//TODO: Temporary labels
            parameters: [:],
            resourceType: .json
        )
    }
}
