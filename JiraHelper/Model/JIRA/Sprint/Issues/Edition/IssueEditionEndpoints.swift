//
//  IssueManipulationEndpoints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum IssueEditionEndpoints {
    static func assign(issue: Issue, to user: User) -> EndpointConfiguration<Nothing> {
        return EndpointConfiguration(
            path: "/api/latest/issue/\(issue.id)/assignee",
            method: .put,
            encoding: JSONEncoding.default,
            headers: [:],
            parameters: [
                "name" : user.name
            ],
            resourceType: .none(Nothing())
        )
    }
}
