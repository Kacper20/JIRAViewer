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
            basePath: "https://\(name).atlassian.net/",
            configuration: TeamCheckEndpoints.team()
        ).map { _ in true }
    }
}
