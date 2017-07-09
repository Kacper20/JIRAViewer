//
//  BasicIssue.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 08/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation


struct BasicIssue: Decodable {
    let id: String
    let key: String
    let summary: String
    let status: IssueStatus
    let assignee: IssueInvolvedPerson?
    let labels: [String]
    let priority: IssuePriority
    let type: IssueType

    private enum CodingKeys: String, CodingKey {
        case id
        case key
        case fields
    }

    private enum FieldsCodingKeys: String, CodingKey {
        case status
        case summary
        case labels
        case assignee
        case priority
        case issuetype
    }

    static var necessaryFields: String {
        return [
            FieldsCodingKeys.status,
            FieldsCodingKeys.summary,
            FieldsCodingKeys.labels,
            FieldsCodingKeys.assignee,
            FieldsCodingKeys.issuetype,
            FieldsCodingKeys.priority
            ].map { $0.rawValue }.joined(separator: ",")
    }

    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try keyedContainer.decode(String.self, forKey: .id)
        key = try keyedContainer.decode(String.self, forKey: .key)
        let fieldsContainer = try keyedContainer.nestedContainer(keyedBy: FieldsCodingKeys.self, forKey: .fields)
        status = try fieldsContainer.decode(IssueStatus.self, forKey: .status)
        assignee = try fieldsContainer.decodeIfPresent(IssueInvolvedPerson.self, forKey: .assignee)
        summary = try fieldsContainer.decode(String.self, forKey: .summary)
        labels = try fieldsContainer.decode([String].self, forKey: .labels)
        priority = try fieldsContainer.decode(IssuePriority.self, forKey: .priority)
        type = try fieldsContainer.decode(IssueType.self, forKey: .issuetype)
    }
}
