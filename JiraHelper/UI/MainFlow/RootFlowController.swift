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

    private let networkService: NetworkService
    private let authenticationProvider: AuthenticationProvider

    var currentFlow: CurrentFlow

    init(networkService: NetworkService, authenticationProvider: AuthenticationProvider) {
        self.networkService = networkService
        self.authenticationProvider = authenticationProvider

        if let authentication = authenticationProvider.readAuthentication() {
            let authenticatedService = AuthenticatedNetworkService(
                networkService: networkService,
                authenticationType: authentication
            )
            currentFlow = .main(MainWindowController(authenticatedNetworkService: authenticatedService))
        } else {
            let teamCheckService = TeamCheckService(networkService: networkService)
            let loginWindowController = LoginWindowController(
                teamCheckService: teamCheckService,
                onFinished: { data in

                }
            )
            currentFlow = .login(loginWindowController)
        }
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
