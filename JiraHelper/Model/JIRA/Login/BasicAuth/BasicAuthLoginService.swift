//
//  BasicAuthLoginService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class BasicAuthLoginService {
    private let networkService: NetworkService
    private let team: JIRATeam

    init(networkService: NetworkService, team: JIRATeam) {
        self.networkService = networkService
        self.team = team
    }

    func login(with data: LoginData) -> Observable<Void> {
        return networkService.request(
            basePath: JIRARestAPI.host(for: team.name),
            configuration: BasicAuthLoginEndpoints.login(with: data)
        )
    }
}
