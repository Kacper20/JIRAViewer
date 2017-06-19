//
//  MainViewModelCreator.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 15/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class MainViewModelCreator {
    private let networkService: AuthenticatedNetworkService
    private let boardsService: BoardsService
    private let sprintsService: SprintsService

    init(networkService: AuthenticatedNetworkService) {
        self.networkService = networkService
        self.boardsService = BoardsService(networkService: networkService)
        self.sprintsService = SprintsService(networkService: networkService)
    }

    func create() -> Observable<MainViewModel> {
        return boardsService
            .boards()
            .flatMap { [weak self] boardsChoice -> Observable<(ActiveSprintChoice, BoardConfiguration, BoardsChoice)> in
                guard let `self` = self else { return .empty() }
                let activeSprints = self.sprintsService.allActive(for: boardsChoice.selected)
                let boardConfiguration = self.boardsService.configuration(for: boardsChoice.selected)
                return Observable.zip(
                activeSprints, boardConfiguration, Observable.just(boardsChoice)) { ($0, $1, $2) }
            }
            .flatMap { [weak self] (activeSprintChoice, boardConfiguration, boardsChoice) -> Observable<MainViewModel> in
                guard let `self` = self else { return .empty() }
                return .just(MainViewModel(
                    boardsService: self.boardsService,
                    sprintsService: self.sprintsService,
                    boardsChoice: boardsChoice,
                    boardConfiguration: boardConfiguration,
                    sprintChoice: activeSprintChoice
                    )
                )
            }
    }
}
