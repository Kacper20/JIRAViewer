//
//  MainWindowMenuManager.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 18/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct MenuItemAction {
    let target: AnyObject
    let selector: Selector
}

struct TeamSwitchItemsInfo {
    let teamNames: [String]
    let target: AnyObject
}

final class MainWindowMenuManager {

    private let menu: NSMenu
    private let logoutAction: MenuItemAction
    private let addTeamAction: MenuItemAction
    private let teamsInfo: TeamSwitchItemsInfo

    init(
        menu: NSMenu,
        logoutAction: MenuItemAction,
        addTeamAction: MenuItemAction,
        teamsInfo: TeamSwitchItemsInfo
        ) {
        self.menu = menu
        self.addTeamAction = addTeamAction
        self.teamsInfo = teamsInfo
        self.logoutAction = logoutAction
        setupMenuItems()
    }

    private func setupMenuItems() {
        guard let menu = NSApp.mainMenu else { return }
        let accountItem = NSMenuItem(
            title: "",
            action: logoutAction.selector,
            keyEquivalent: ""
        )
        menu.insertItem(accountItem, at: 1)
        let accountMenu = NSMenu(title: "Account")
        accountItem.submenu = accountMenu
        let logoutItem = NSMenuItem(
            title: "Logout",
            action: logoutAction.selector,
            keyEquivalent: ""
        )
        logoutItem.target = logoutAction.target
        logoutItem.isEnabled = true
        accountMenu.insertItem(logoutItem, at: 0)
        let addTeamItem = NSMenuItem(
            title: "Add team",
            action: addTeamAction.selector,
            keyEquivalent: ""
        )
        addTeamItem.target = addTeamAction.target
        addTeamItem.isEnabled = true
        accountMenu.insertItem(addTeamItem, at: 1)
    }

}
