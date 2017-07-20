//
//  MainViewModel.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 15/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

//TODO: Rename to service?
final class MainViewModel {

    private let boardsService: BoardsService
    private let sprintsService: SprintsService

    let boardsChoice: BoardsChoice
    let sprintChoice: ActiveSprintChoice
    let eventsReceiver: GlobalUIEventsReceiver
    let imageDownloader: ImageDownloader
    let otherTeams: [JIRATeam]

    let sprintViewModel: SprintViewModel
    //TODO: Consider connecting boards choice selected with configuration to express type in a better way
    init(
        boardsService: BoardsService,
        sprintsService: SprintsService,
        boardsChoice: BoardsChoice,
        boardConfiguration: BoardConfiguration,
        eventsReceiver: GlobalUIEventsReceiver,
        sprintChoice: ActiveSprintChoice,
        user: User,
        otherTeams: [JIRATeam],
        imageDownloader: ImageDownloader = ImageDownloader()
     ) {
        self.boardsService = boardsService
        self.sprintsService = sprintsService
        self.boardsChoice = boardsChoice
        self.sprintChoice = sprintChoice
        self.eventsReceiver = eventsReceiver
        self.otherTeams = otherTeams
        self.sprintViewModel = SprintViewModel(
            sprintIssuesService: sprintsService.issuesService(for: sprintChoice.selected),
            imageDownloader: imageDownloader,
            boardConfiguration: boardConfiguration,
            eventsReceiver: eventsReceiver,
            user: user
        )
        self.imageDownloader = imageDownloader
    }
}
