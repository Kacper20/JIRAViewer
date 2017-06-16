//
//  MainViewModel.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 15/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class MainViewModel {

    private let boardsService: BoardsService
    private let sprintsService: SprintsService
    let boardsChoice: BoardsChoice
    let sprintChoice: ActiveSprintChoice

    init(
        boardsService: BoardsService,
        sprintsService: SprintsService,
        boardsChoice: BoardsChoice,
        sprintChoice: ActiveSprintChoice
     ) {
        self.boardsService = boardsService
        self.sprintsService = sprintsService
        self.boardsChoice = boardsChoice
        self.sprintChoice = sprintChoice
    }
}
