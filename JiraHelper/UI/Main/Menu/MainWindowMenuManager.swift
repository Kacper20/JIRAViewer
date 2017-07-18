//
//  MainWindowMenuManager.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 18/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum MainWindowMenuAction {
    case logout
}

final class MainWindowMenuManager {

    private let menu: NSMenu
    private let actionHandler: (MainWindowMenuAction) -> Void

    init(menu: NSMenu, actionHandler: @escaping (MainWindowMenuAction) -> Void) {
        self.menu = menu
        self.actionHandler = actionHandler
        setupMenuItems()
    }

    private func setupMenuItems() {
        guard let menu = NSApp.mainMenu else { return }
        let accountItem = NSMenuItem(
            title: "",
            action: #selector(MainWindowMenuManager.logoutClicked),
            keyEquivalent: ""
        )
        menu.insertItem(accountItem, at: 1)
        let accountMenu = NSMenu(title: "Account")
        accountItem.submenu = accountMenu
        let logoutItem = NSMenuItem(
            title: "Logout",
            action: #selector(MainWindowMenuManager.logoutClicked),
            keyEquivalent: ""
        )
        logoutItem.target = self
        logoutItem.isEnabled = true
        accountMenu.insertItem(logoutItem, at: 0)
    }

    @objc private func logoutClicked() {
        actionHandler(.logout)
    }

}
