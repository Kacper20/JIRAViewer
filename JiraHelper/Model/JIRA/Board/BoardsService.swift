//
//  BoardsService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

struct BoardsChoice {
    let selected: Board
    let rest: [Board]

    init?(boards: [Board]) {
        guard let (head, tail) = boards.decomposed() else { return nil }
        self.selected = head
        self.rest = tail
    }
}

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
