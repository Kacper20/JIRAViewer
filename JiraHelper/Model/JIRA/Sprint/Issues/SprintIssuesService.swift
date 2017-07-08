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

    func getAll() -> Observable<[BasicIssue]> {
        let allConfig = IssuesEndpoints.all(forSprint: sprint)
        return networkService.request(configuration: allConfig).map { $0.values }
    }

    func getDetailedIssue(for issue: IssueIdentifiable) -> Observable<DetailedIssue> {
        return networkService.request(configuration: IssuesEndpoints.detailedIssue(for: issue))
    }

    func issueEditionService(for issue: BasicIssue) -> IssueEditionService {
        return IssueEditionService(networkService: networkService, issue: issue)
    }
}
