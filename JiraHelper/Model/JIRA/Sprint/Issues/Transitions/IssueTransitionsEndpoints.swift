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
            method: .get,
            encoding: JSONEncoding.default,
            headers: [:],
            parameters: [:],
            resourceType: .json
        )
    }

    struct TransitionCommand: Encodable {
        let transition: IssueTransition

        private enum CodingKeys: String, CodingKey {
            case transition
        }

        private enum TransitionCodingKeys: String, CodingKey {
            case id
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            var transitionInfo = container.nestedContainer(keyedBy: TransitionCodingKeys.self, forKey: .transition)
            try transitionInfo.encode(transition.id, forKey: .id)
        }
    }

    static func performTransition(
        _ transition: IssueTransition,
        for issue: IssueIdentifiable
        ) -> EndpointConfiguration<Nothing> {
        let command = TransitionCommand(transition: transition)
        let encoder = JSONEncoder()
        return EndpointConfiguration(
            path: "/api/latest/issue/\(issue.id)/transitions",
            method: .post,
            encoding: JSONEncoding.default,
            headers: [:],
            parameters: [:],
            resourceType: .none(Nothing())
        )
    }
}
