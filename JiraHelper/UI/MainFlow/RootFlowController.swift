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
    private let environment = Environment()

    var currentFlow: CurrentFlow

    init(networkService: NetworkService, authenticationProvider: AuthenticationProvider) {
        self.networkService = networkService
        self.authenticationProvider = authenticationProvider

        if let authentication = authenticationProvider.readAuthentication() {
            if case let .basicAuth(storage) = authentication {
                let authenticatedService = AuthenticatedNetworkService(
                    networkService: networkService,
                    authentication: storage
                )
                currentFlow = .main(MainWindowController(authenticatedNetworkService: authenticatedService))
            } else {
                fatalError()
            }
        } else {
            let teamCheckService = TeamCheckService(networkService: networkService, environment: environment)
            let loginWindowController = LoginWindowController(
                teamCheckService: teamCheckService
            )
            currentFlow = .login(loginWindowController)
            loginWindowController.onFinished = { [weak self] data in
                self?.performLogin(withAuthentication: data.authenticationData, team: data.team)
            }
        }
    }

    private func performLogin(withAuthentication authenticationType: AuthenticationDataType, team: JIRATeam) {
        switch authenticationType {
        case let .basic(loginData):
            let storage = authenticationProvider.writeBasicAuthentication(data: loginData, team: team)
            let authenticatedService = AuthenticatedNetworkService(
                networkService: networkService,
                authentication: storage
            )
            if case let .login(controller) = currentFlow {
                controller.close()
            }
            //TODO: Should be generic
            currentFlow = .main(MainWindowController(authenticatedNetworkService: authenticatedService))
        case .cookie(_):
            fatalError()
        }
    }

    func present() {
        let flow: CurrentFlow = currentFlow
        switch flow {
        case let .login(controller):
            
            controller.present()
        case let .main(controller):
            controller.present()
        }
    }
}
