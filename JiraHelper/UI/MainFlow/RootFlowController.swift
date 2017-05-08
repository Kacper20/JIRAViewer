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
        case main
    }

    var currentFlow: CurrentFlow

    init() {
        currentFlow = .login(LoginWindowController())
    }

    func present() {
        if case let .login(controller) = currentFlow {
            controller.present()
        }
    }
}
