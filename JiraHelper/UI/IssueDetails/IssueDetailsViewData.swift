//
//  IssueDetailsViewData.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 05/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct PersonData {
    let role: String
    let name: String
    let avatarUrl: String
}

struct IssueDetailsViewData {
    let keyName: String
    let title: String
    let peopleInvolved: [PersonData]
}

extension IssueDetailsViewData {
    init(issue: Issue) {
        self.keyName = issue.key
        self.title = issue.summary
        self.peopleInvolved = []
    }
}
