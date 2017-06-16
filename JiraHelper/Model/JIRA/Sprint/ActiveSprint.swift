//
//  ActiveSprint.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct ActiveSprint {
    let setupData: SprintSetupData
    let id: Int
    let url: String
    let name: String
    let goal: String?

    init?(sprint: Sprint) {
        guard case let .active(setupData) = sprint.state else { return nil }
        self.setupData = setupData
        self.id = sprint.id
        self.url = sprint.url
        self.name = sprint.name
        self.goal = sprint.goal
    }
}
