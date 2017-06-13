//
//  BoardsService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class BoardService {
    private let networkService: AuthenticatedNetworkService

    init(networkService: AuthenticatedNetworkService) {
        self.networkService = networkService
    }

    func allBoards() -> Observable<[Board]> {
        return networkService.request(
            configuration: BoardEndpoints.boards()
        )
        .map { $0.values }
    }
}
