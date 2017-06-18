//
//  SprintIssuesService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class SprintIssuesService {
    private let networkService: AuthenticatedNetworkService
    private let sprint: ActiveSprint

    init(networkService: AuthenticatedNetworkService, sprint: ActiveSprint) {
        self.networkService = networkService
        self.sprint = sprint
    }

    func getAll() -> Observable<[Issue]> {
        let allConfig = IssuesEndpoints.all(forSprint: sprint)
        return networkService.request(configuration: allConfig).map { $0.values }
    }
}
