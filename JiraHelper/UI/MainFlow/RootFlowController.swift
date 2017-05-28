//
//  MainFlowController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class RootFlowController {

    enum CurrentFlow {
        case login(LoginWindowController)
        case main(MainWindowController)
    }

    var currentFlow: CurrentFlow

    init(teamCheckService: TeamCheckService) {
        currentFlow = .login(LoginWindowController(teamCheckService: teamCheckService))
    }

    func present() {
        switch currentFlow {
        case let .login(controller):
            controller.present()
        case let .main(controller):
            break
        }
    }
}
