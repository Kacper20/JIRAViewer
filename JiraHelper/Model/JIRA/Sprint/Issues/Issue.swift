//
//  Issue.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct Issue: Decodable {
    let id: String
    let key: String
    let summary: String
    let status: IssueStatus
    let labels: [String]

    private enum CodingKeys: String, CodingKey {
        case id
        case key
        case fields
    }

    private enum FieldsCodingKeys: String, CodingKey {
        case status
        case summary
        case labels
    }

    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try keyedContainer.decode(String.self, forKey: .id)
        key = try keyedContainer.decode(String.self, forKey: .key)
        let fieldsContainer = try keyedContainer.nestedContainer(keyedBy: FieldsCodingKeys.self, forKey: .fields)
        status = try fieldsContainer.decode(IssueStatus.self, forKey: .status)
        summary = try fieldsContainer.decode(String.self, forKey: .summary)
        labels = try fieldsContainer.decode([String].self, forKey: .labels)
    }
}
