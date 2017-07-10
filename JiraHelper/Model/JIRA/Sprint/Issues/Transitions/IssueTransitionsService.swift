//
//  IssueTransitionsService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 10/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class IssueTransitionsService {
    private let networkService: AuthenticatedNetworkService

    init(networkService: AuthenticatedNetworkService) {
        self.networkService = networkService
    }

    func getTransitions(for issue: IssueIdentifiable) -> Observable<[IssueTransition]> {
        return networkService.request(configuration: IssueTransitionsEndpoints.getTransitions(for: issue))
            .map { $0.transitions }
    }
}
