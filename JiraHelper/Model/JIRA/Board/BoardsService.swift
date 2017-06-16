//
//  BoardsService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

enum BoardsServiceError: Error {
    case noValidBoards
}

final class BoardsService {
    private let networkService: AuthenticatedNetworkService

    init(networkService: AuthenticatedNetworkService) {
        self.networkService = networkService
    }

    func boards() -> Observable<BoardsChoice> {
        return networkService.request(
            configuration: BoardEndpoints.boards()
        )
        .map { $0.values }
        .flatMap { boards -> Observable<BoardsChoice> in
            if let choice = BoardsChoice(boards: boards) {
                return .just(choice)
            } else {
                return .error(BoardsServiceError.noValidBoards)
            }
        }
    }
}
