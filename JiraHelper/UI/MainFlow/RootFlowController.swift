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
//        try? authenticationProvider.clearAuthentication()
    }

    private func computeCurrentFlow() -> CurrentFlow {
        if let authentication = authenticationProvider.getLastAuthenticationData() {
            return createMainFlowChoice(
                for: authentication,
                eventsReceiver: eventsReceiver,
                networkService: networkService
            )
        } else {
            let teamCheckService = TeamCheckService(networkService: networkService, environment: environment)
            let loginWindowController = LoginWindowController(
                teamCheckService: teamCheckService
            )
            loginWindowController.onFinished = { [weak self] data in
                _ = self?.authenticationProvider.writeAuthentication(data.authenticationData, team: data.team)
                self?.relaunchProperFlow()
            }
            return .login(loginWindowController)
        }
    }

    private func createMainFlowChoice(
        for storage: AuthenticationStorageItem,
        eventsReceiver: GlobalUIEventsReceiver,
        networkService: NetworkService
        ) -> CurrentFlow {
        let authenticatedService = AuthenticatedNetworkService(networkService: networkService, authentication: storage)
        let mainController = MainWindowController(
            mainViewModelCreator: MainViewModelCreator(
                networkService: authenticatedService,
                eventsReceiver: eventsReceiver,
                authenticationProvider: authenticationProvider
            ),
            actionHandler: { [weak self] action in
                switch action {
                case .logout:
                    try? self?.authenticationProvider.clearAuthentication()
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
