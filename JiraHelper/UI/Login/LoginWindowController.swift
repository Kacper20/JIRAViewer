//
//  LoginWindowController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Cocoa

class LoginWindowController: NSWindowController {

    private var loginFlowContainer: LoginFlowContainerViewController?
    private let teamCheckService: TeamCheckService
    private let onFinished: (LoginFlowCompletedData) -> Void

    init(teamCheckService: TeamCheckService, onFinished: @escaping (LoginFlowCompletedData) -> Void) {
        self.teamCheckService = teamCheckService
        self.onFinished = onFinished
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var windowNibName : String! {
        return "LoginWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        let loginFlowContainer = LoginFlowContainerViewController(
            teamCheckService: teamCheckService,
            onFinished: { [weak self] data in
                self?.onFinished(data)
            })
        self.loginFlowContainer = loginFlowContainer
        window?.contentView?.addSubview(loginFlowContainer.view)
        loginFlowContainer.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func present() {
        window?.makeKey()
    }
    
}
