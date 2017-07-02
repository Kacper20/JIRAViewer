//
//  IssueEditionService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 02/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class IssueEditionService {
    private let networkService: AuthenticatedNetworkService
    private var issue: Issue

    init(networkService: AuthenticatedNetworkService, issue: Issue) {
        self.networkService = networkService
        self.issue = issue
    }

    func assign(to user: User) -> Observable<Issue> {
        return networkService.request(configuration: IssueEditionEndpoints.assign(issue: issue, to: user))
            .flatMap { _ in
                return self.networkService.request(configuration: IssuesEndpoints.issue(withId: self.issue.id))
            }
    }
}
