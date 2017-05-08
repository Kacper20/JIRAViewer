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

    override var windowNibName : String! {
        return "LoginWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        let loginFlowContainer = LoginFlowContainerViewController()
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
