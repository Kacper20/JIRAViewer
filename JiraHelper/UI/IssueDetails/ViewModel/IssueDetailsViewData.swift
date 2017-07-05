//
//  IssueDetailsViewData.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 05/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct IssueDetailsViewData {
    let keyName: String
    let title: String
    let peopleInvolved: [PersonData]
}

extension IssueDetailsViewData {
    init(issue: Issue) {
        self.keyName = issue.key
        self.title = issue.summary
        var people = [PersonData(role: "Creator", person: issue.creator)]
        if let assignee = issue.assignee {
            people.append(PersonData(role: "Assignee", person: assignee))
        }
        self.peopleInvolved = people
    }
}
