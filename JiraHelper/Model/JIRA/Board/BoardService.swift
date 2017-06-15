//
//  BoardsService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

enum BoardServiceError: Error {
    case noValidBoards
}

struct BoardsResult {
   t let selectedBoard: Board
    let rest: [Board]
}

final class BoardService {
    private let networkService: AuthenticatedNetworkService

    init(networkService: AuthenticatedNetworkService) {
        self.networkService = networkService
    }

    func boards() -> Observable<BoardsResult> {
        return networkService.request(
            configuration: BoardEndpoints.boards()
        )
        .map { $0.values }
        .flatMap { boards -> Observable<BoardsResult> in
            guard let first = boards.first else {
                return .error(BoardServiceError.noValidBoards)
            }
            return .just(BoardsResult(selectedBoard: first, rest: Array(boards.dropFirst())))
        }
    }
}
