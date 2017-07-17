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
    private let eventsReceiver = GlobalUIEventsReceiver()
    private let environment = Environment()

    var currentFlow: CurrentFlow!

    init(networkService: NetworkService, authenticationProvider: AuthenticationProvider) {
        self.networkService = networkService
        self.authenticationProvider = authenticationProvider
        currentFlow = computeCurrentFlow()
    }

    private func computeCurrentFlow() -> CurrentFlow {
        if let authentication = authenticationProvider.readAuthentication() {
            if case let .basicAuth(storage) = authentication {
                return createMainFlowChoice(
                    for: storage,
                    eventsReceiver: eventsReceiver,
                    networkService: networkService
                )
            } else {
                fatalError()
            }
        } else {
            let teamCheckService = TeamCheckService(networkService: networkService, environment: environment)
            let loginWindowController = LoginWindowController(
                teamCheckService: teamCheckService
            )
            loginWindowController.onFinished = { [weak self] data in
                self?.performLogin(withAuthentication: data.authenticationData, team: data.team)
            }
            return .login(loginWindowController)
        }
    }

    private func performLogin(withAuthentication authenticationType: AuthenticationDataType, team: JIRATeam) {
        switch authenticationType {
        case let .basic(loginData):
            let storage = authenticationProvider.writeBasicAuthentication(data: loginData, team: team)
            cleanCurrentFlow()
            currentFlow = createMainFlowChoice(
                for: storage,
                eventsReceiver: eventsReceiver,
                networkService: networkService
            )
            present()
        case .cookie(_):
            fatalError()
        }
    }

    private func createMainFlowChoice(
        for storage: AuthenticationStorage,
        eventsReceiver: GlobalUIEventsReceiver,
        networkService: NetworkService
        ) -> CurrentFlow {
        let authenticatedService = AuthenticatedNetworkService(networkService: networkService, authentication: storage)
        let mainController = MainWindowController(
            mainViewModelCreator: MainViewModelCreator(
                networkService: authenticatedService,
                eventsReceiver: eventsReceiver
            ),
            actionHandler: { [weak self] action in
                switch action {
                case .logoutClicked:
                    try? storage.deleteFromSecureStore()
                    self?.relaunchProperFlow()
                }
            }
        )
        return .main(mainController)
    }

    private func relaunchProperFlow() {
        cleanCurrentFlow()
        currentFlow = computeCurrentFlow()
        present()
    }

    //TODO: Maybe some more in-out functions, not depending on state
    private func cleanCurrentFlow() {
        guard let flow = currentFlow else { return }
        switch flow {
        case let .login(controller):
            controller.close()
        case let .main(controller):
            controller.close()
        }
    }

    func present() {
        guard let flow = currentFlow else { return }
        switch flow {
        case let .login(controller):
            controller.present()
        case let .main(controller):
            controller.present()
        }
    }
}
