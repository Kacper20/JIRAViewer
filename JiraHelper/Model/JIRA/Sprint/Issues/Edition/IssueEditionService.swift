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
    private var issue: BasicIssue

    init(networkService: AuthenticatedNetworkService, issue: BasicIssue) {
        self.networkService = networkService
        self.issue = issue
    }

    func assign(to user: User) -> Observable<BasicIssue> {
        return networkService.request(configuration: IssueEditionEndpoints.assign(issue: issue, to: user))
            .flatMap { _ in
                return self.networkService.request(configuration: IssuesEndpoints.basicIssue(for: self.issue))
            }
    }
}
