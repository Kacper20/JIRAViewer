//
//  SprintsService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 15/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

struct ActiveSprintChoice {
    let selected: ActiveSprint
    let rest: [ActiveSprint]

    init?(sprints: [Sprint]) {
        let activeSprints = sprints.flatMap(ActiveSprint.init)
        guard let (head, tail) = activeSprints.decomposed() else { return nil }
        self.selected = head
        self.rest = tail
    }
}

enum SprintsServiceError: Error {
    case noSprints
}

final class SprintsService {
    private let networkService: AuthenticatedNetworkService

    init(networkService: AuthenticatedNetworkService) {
        self.networkService = networkService
    }

    func issuesService(for sprint: ActiveSprint) -> SprintIssuesService {
        return SprintIssuesService(networkService: networkService, sprint: sprint)
    }

    func allActive(for board: Board) -> Observable<ActiveSprintChoice> {
        return networkService.request(configuration: SprintEndpoints.allActive(forBoard: board))
            .map { $0.values }
            .flatMap { sprints -> Observable<ActiveSprintChoice> in
                if let choice = ActiveSprintChoice(sprints: sprints) {
                    return .just(choice)
                } else {
                    return .error(SprintsServiceError.noSprints)
                }
            }
    }
}
