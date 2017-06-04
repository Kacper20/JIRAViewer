//
//  CookiesAuthLoginService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 02.06.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class CookiesAuthLoginService: LoginService {
    private let networkService: NetworkService
    private let team: JIRATeam

    init(networkService: NetworkService, team: JIRATeam) {
        self.networkService = networkService
        self.team = team
    }

    func login(with data: LoginData) -> Observable<CookieSessionWithLoginData> {
        return networkService.request(
            basePath: JIRARestAPI.host(for: team.name),
            configuration: CookieAuthLoginEndpoints.login(with: data)
        ).map { CookieSessionWithLoginData(session: $0, loginData: data) }
    }
}
