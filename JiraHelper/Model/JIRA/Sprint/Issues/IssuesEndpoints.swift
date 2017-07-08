//
//  SprintIssuesEndpoints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum IssuesEndpoints {
    static func all(forSprint sprint: ActiveSprint) -> EndpointConfiguration<ArrayOfValuesWithPagingData<BasicIssue>> {
        return EndpointConfiguration(
            path: "/agile/latest/board/\(sprint.setupData.originBoardId)/sprint/\(sprint.id)/issue",
            method: .get,
            encoding: URLEncoding.default,
            headers: [:],//TODO: Temporary labels
            parameters: [
                "jql" : "labels = iOS",
                "fields" : BasicIssue.necessaryFields
            ],
            resourceType: .json
        )
    }

    static func basicIssue(for issue: IssueIdentifiable) -> EndpointConfiguration<BasicIssue> {
        let detailConfig = IssuesEndpoints.detailedIssue(for: issue)
        //TODO: Use lenses in future
        return EndpointConfiguration(
            path: detailConfig.path,
            method: detailConfig.method,
            encoding: detailConfig.encoding,
            headers: detailConfig.headers,
            parameters: ["fields" : BasicIssue.necessaryFields],
            resourceType: .json
        )
    }

    static func detailedIssue(for issue: IssueIdentifiable) -> EndpointConfiguration<DetailedIssue> {
        return EndpointConfiguration(
            path: "/api/latest/issue/\(issue.id)",
            method: .get,
            encoding: URLEncoding.default,
            headers: [:],
            parameters: [:],
            resourceType: .json
        )
    }
}
