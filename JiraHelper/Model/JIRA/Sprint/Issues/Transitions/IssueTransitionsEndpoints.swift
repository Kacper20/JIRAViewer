//
//  IssueTransitionsEndpoints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 10/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum IssueTransitionsEndpoints {

    struct GetTransitionsResult: Decodable {
        let transitions: [IssueTransition]
    }

    static func getTransitions(for issue: IssueIdentifiable) -> EndpointConfiguration<GetTransitionsResult> {
        return EndpointConfiguration(
            path: "/api/latest/issue/\(issue.id)/transitions",
            method: .put,
            encoding: JSONEncoding.default,
            headers: [:],
            parameters: [:],
            resourceType: .json
        )
    }
}
