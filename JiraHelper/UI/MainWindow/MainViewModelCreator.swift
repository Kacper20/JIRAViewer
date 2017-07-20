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
    private let userService: UserService
    private let eventsReceiver: GlobalUIEventsReceiver
    private let authenticationProvider: AuthenticationProvider

    init(
        networkService: AuthenticatedNetworkService,
        eventsReceiver: GlobalUIEventsReceiver,
        authenticationProvider: AuthenticationProvider
        ) {
        self.networkService = networkService
        self.boardsService = BoardsService(networkService: networkService)
        self.sprintsService = SprintsService(networkService: networkService)
        self.userService = UserService(networkService: networkService)
        self.eventsReceiver = eventsReceiver
        self.authenticationProvider = authenticationProvider
    }

    func create() -> Observable<MainViewModel> {
        let boardsAndSprint = boardsService
            .boards()
            .flatMap { [weak self] boardsChoice -> Observable<(ActiveSprintChoice, BoardConfiguration, BoardsChoice)> in
                guard let `self` = self else { return .empty() }
                let activeSprints = self.sprintsService.allActive(for: boardsChoice.selected)
                let boardConfiguration = self.boardsService.configuration(for: boardsChoice.selected)
                return Observable.zip(
                activeSprints, boardConfiguration, Observable.just(boardsChoice)) { ($0, $1, $2) }
            }
        let user = userService.getMyself()
        return Observable.zip(boardsAndSprint, user, resultSelector: { ($0.0.0, $0.0.1, $0.0.2, $0.1) })
            .flatMap { [weak self] (activeSprintChoice, boardConfig, boardsChoice, user) -> Observable<MainViewModel> in
                guard let `self` = self else { return .empty() }
                    return .just(MainViewModel(
                        boardsService: self.boardsService,
                        sprintsService: self.sprintsService,
                        boardsChoice: boardsChoice,
                        boardConfiguration: boardConfig,
                        eventsReceiver: self.eventsReceiver,
                        sprintChoice: activeSprintChoice,
                        user: user,
                        otherTeams: self.authenticationProvider.getOtherThanLastTeams()
                        )
                    )
                }
        }
}
