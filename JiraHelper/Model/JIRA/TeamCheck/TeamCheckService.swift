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
    private let environment: Environment

    init(networkService: NetworkService, environment: Environment) {
        self.networkService = networkService
        self.environment = environment
    }

    func checkTeamAvailability(for name: String) -> Observable<Bool> {
        return networkService.request(
            basePath: JIRARestAPI.host(for: name),
            configuration: TeamCheckEndpoints.team()
        ).map { _ in true }
    }

    enum LoginServiceKind {
        case basicAuth(BasicAuthLoginService)
        case cookies(CookiesAuthLoginService)
    }

    func loginService(forTeam team: JIRATeam) -> LoginServiceKind {
        switch environment.authentication {
        case .basicAuth:
            return .basicAuth(BasicAuthLoginService(networkService: networkService, team: team))
        case .cookies:
            return .cookies(CookiesAuthLoginService(networkService: networkService, team: team))
        }
    }
}
