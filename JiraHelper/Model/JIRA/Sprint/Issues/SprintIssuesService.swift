//
//  SprintIssuesService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class SprintIssuesService {
    private let networkService: AuthenticatedNetworkService
    private let sprint: Sprint

    init(networkService: AuthenticatedNetworkService, sprint: Sprint) {
        self.networkService = networkService
        self.sprint = sprint
    }
}
