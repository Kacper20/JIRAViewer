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
                currentFlow = RootFlowController.createMainFlowChoice(for: storage, networkService: networkService)
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
            if case let .login(controller) = currentFlow {
                controller.close()
            }
            currentFlow = RootFlowController.createMainFlowChoice(for: storage, networkService: networkService)
        case .cookie(_):
            fatalError()
        }
    }

    private static func createMainFlowChoice(
        for storage: BasicAuthenticationStorage,
        networkService: NetworkService
        ) -> CurrentFlow {
        let authenticatedService = AuthenticatedNetworkService(networkService: networkService, authentication: storage)
        let mainController = MainWindowController(
            mainViewModelCreator: MainViewModelCreator(networkService: authenticatedService)
        )
        return .main(mainController)
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
