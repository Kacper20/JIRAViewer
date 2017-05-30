//
//  LoginFlowContainerViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class LoginFlowContainerViewController: NSViewController {

    private let teamCheckService: TeamCheckService

    init(teamCheckService: TeamCheckService) {
        self.teamCheckService = teamCheckService
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
        let basicAuthViewModel = BasicAuthLoginViewModel(service: teamCheckService.loginService(forTeam: team))

        let loginVc = BasicAuthLoginViewController(
            team: team,
            viewModel: basicAuthViewModel
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
        vc.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
