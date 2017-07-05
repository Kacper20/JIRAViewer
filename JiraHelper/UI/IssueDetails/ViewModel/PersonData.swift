//
//  PersonData.swift
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

extension PersonData {
    init(role: String, person: IssueInvolvedPerson) {
        self.role = role
        self.name = person.name
        self.avatarUrl = person.avatarUrl
    }
}
