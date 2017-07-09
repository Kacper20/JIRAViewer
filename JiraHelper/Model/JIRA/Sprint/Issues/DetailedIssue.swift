//
//  Issue.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct DetailedIssue: Decodable {
    let id: String
    let key: String
    let summary: String
    let description: String
    let created: Date
    let lastViewed: Date?
    let status: IssueStatus
    let assignee: IssueInvolvedPerson?
    let creator: IssueInvolvedPerson
    let labels: [String]
    let priority: IssuePriority
    let comments: [IssueComment]
    let type: IssueType

    private enum CodingKeys: String, CodingKey {
        case id
        case key
        case fields
        case renderedFields
    }

    private enum FieldsCodingKeys: String, CodingKey {
        case status
        case created
        case lastViewed
        case summary
        case labels
        case assignee
        case creator
        case description
        case priority
        case comment
        case issuetype
    }
    private enum CommentCodingKeys: String, CodingKey {
        case comments
    }

    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try keyedContainer.decode(String.self, forKey: .id)
        key = try keyedContainer.decode(String.self, forKey: .key)
        let fieldsContainer = try keyedContainer.nestedContainer(keyedBy: FieldsCodingKeys.self, forKey: .fields)
        let renderedFields = try keyedContainer.nestedContainer(keyedBy: FieldsCodingKeys.self, forKey: .renderedFields)
        status = try fieldsContainer.decode(IssueStatus.self, forKey: .status)
        assignee = try fieldsContainer.decodeIfPresent(IssueInvolvedPerson.self, forKey: .assignee)
        creator = try fieldsContainer.decode(IssueInvolvedPerson.self, forKey: .creator)
        summary = try fieldsContainer.decode(String.self, forKey: .summary)
        created = try fieldsContainer.decode(Date.self, forKey: .created)
        lastViewed = try fieldsContainer.decodeIfPresent(Date.self, forKey: .lastViewed)
        labels = try fieldsContainer.decode([String].self, forKey: .labels)
        description = try renderedFields.decode(String.self, forKey: .description)
        priority = try fieldsContainer.decode(IssuePriority.self, forKey: .priority)
        let commentContainer = try renderedFields.nestedContainer(keyedBy: CommentCodingKeys.self, forKey: .comment)
        comments = try commentContainer.decode([IssueComment].self, forKey: .comments)
        type = try fieldsContainer.decode(IssueType.self, forKey: .issuetype)
    }
}
