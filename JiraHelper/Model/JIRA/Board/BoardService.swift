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
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func allBoards() -> Observable<[Board]> {
        //TODO: Hardcoded URL
        return networkService.request(
            basePath: "",
            configuration: BoardEndpoints.boards()
        )
        .map { $0.values }
    }
}
