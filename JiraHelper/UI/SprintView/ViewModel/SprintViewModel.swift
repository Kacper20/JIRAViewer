//
//  SprintViewModel.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class SprintViewModel: NSCollectionViewDataSource {

    private let sprintIssuesService: SprintIssuesService

    init(sprintIssuesService: SprintIssuesService) {
        self.sprintIssuesService = sprintIssuesService
    }

    
}
