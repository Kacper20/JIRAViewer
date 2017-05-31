//
//  TeamCheckService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 09.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class TeamCheckService {

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func checkTeamAvailability(for name: String) -> Observable<Bool> {
        return networkService.request(
            basePath: JIRARestAPI.host(for: name),
            configuration: TeamCheckEndpoints.team()
        ).map { _ in true }
    }

    func loginService(forTeam team: JIRATeam) -> BasicAuthLoginService {
        return BasicAuthLoginService(networkService: networkService, team: team)
    }
}
