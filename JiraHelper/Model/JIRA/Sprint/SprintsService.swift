//
//  SprintsService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 15/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class SprintsService {
    private let networkService: AuthenticatedNetworkService

    init(networkService: AuthenticatedNetworkService) {
        self.networkService = networkService
    }

    func allActive(for board: Board) -> Observable<[Sprint]> {
        return networkService.request(configuration: SprintEndpoints.all(forBoard: board))
            .map { $0.values }
    }
}
