//
//  LoginFlowContainerViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct LoginFlowCompletedData {
    let team: JIRATeam
    let authenticationData: AuthenticationDataType
}

final class LoginFlowContainerViewController: NSViewController {

    private let teamCheckService: TeamCheckService
    private let onFinished: (LoginFlowCompletedData) -> Void

    init(
        teamCheckService: TeamCheckService,
        onFinished: @escaping (LoginFlowCompletedData) -> Void
        ) {
        self.teamCheckService = teamCheckService
        self.onFinished = onFinished
        super.init(nibName: nil, bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presentTeamPickerVC()
    }

    private func presentTeamPickerVC() {
        let viewModel = TeamPickerViewModel(teamCheckService: teamCheckService)
        let teamPickerVc = TeamPickerViewController(
            viewModel: viewModel,
            actionHandler: { [weak self] action in
                switch action {
                case let .teamPicked(team):
                    self?.presentBasicAuthLoginVC(withTeam: team)
                }
            }
        )
        setVCAsCurrent(vc: teamPickerVc)
    }

    private func presentBasicAuthLoginVC(withTeam team: JIRATeam) {
        switch teamCheckService.loginService(forTeam: team) {
        case .basicAuth(let service):
            let viewModel = LoginViewModel(service: service)
            setProperLoginVC(viewModel: viewModel, team: team, onFinish: { [weak self] result in
                self?.onFinished(LoginFlowCompletedData(team: team, authenticationData: .basic(result)))
            })
        case .cookies(let service):
            let viewModel = LoginViewModel(service: service)
            setProperLoginVC(viewModel: viewModel, team: team, onFinish: { [weak self] result in
                self?.onFinished(LoginFlowCompletedData(team: team, authenticationData: .cookie(result)))
            })
        }
    }

    private func setProperLoginVC<T: LoginViewModelType>(
        viewModel model: T,
        team: JIRATeam,
        onFinish: @escaping (T.LoginResult) -> Void
        ) {
        let loginVc = LoginViewController<T>(
            team: team,
            viewModel: model,
            onLoggedIn: onFinish
        )
        setVCAsCurrent(vc: loginVc)
    }

    private func setVCAsCurrent(vc: NSViewController) {
        childViewControllers.forEach { controller in
            controller.removeFromParentViewController()
            controller.view.removeFromSuperview()
        }
        addChildViewController(vc)
        view.addSubview(vc.view)
        vc.view.constraintEdgesToSuperview()
    }
}
