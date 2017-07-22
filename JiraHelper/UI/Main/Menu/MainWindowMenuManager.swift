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
    let teams: [JIRATeam]
    let target: AnyObject
    let selector: Selector
}

final class MainWindowMenuManager {

    private let menu: NSMenu
    private let logoutAction: MenuItemAction
    private let addTeamAction: MenuItemAction
    private let teamsInfo: TeamSwitchItemsInfo
    private var teamSwitchItems = [NSMenuItem]()

    private var accountItem: NSMenuItem?

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

    func clearItems() {
        if let item = accountItem {
            menu.removeItem(item)
        }
    }

    private func setupMenuItems() {
        let accountItem = NSMenuItem(
            title: "",
            action: logoutAction.selector,
            keyEquivalent: ""
        )
        self.accountItem = accountItem
        menu.insertItem(accountItem, at: 1)
        let accountMenu = NSMenu(title: "Account")
        accountItem.submenu = accountMenu
        let logoutItem = NSMenuItem(
            title: "Logout",
            action: logoutAction.selector,
            keyEquivalent: ""
        )
        logoutItem.target = logoutAction.target
        accountMenu.insertItem(logoutItem, at: 0)
        let addTeamItem = NSMenuItem(
            title: "Add team",
            action: addTeamAction.selector,
            keyEquivalent: ""
        )
        addTeamItem.target = addTeamAction.target
        accountMenu.insertItem(addTeamItem, at: 1)

        if !teamsInfo.teams.isEmpty {
            let switchTeamItem = NSMenuItem(
                title: "Switch team",
                action: teamsInfo.selector,
                keyEquivalent: ""
            )
            accountMenu.insertItem(switchTeamItem, at: 2)
            let menu = NSMenu(title: "submenu")
            switchTeamItem.submenu = menu
            let teamItems = teamsInfo.teams.map { team in
                return NSMenuItem(
                    title: team.name,
                    action: teamsInfo.selector,
                    keyEquivalent: ""
                )
            }
            self.teamSwitchItems = teamItems
            teamItems.forEach { menu.addItem($0) }

        }
    }

    func matchMenuItemToTeam(item: NSMenuItem) -> JIRATeam? {
        if let index = teamSwitchItems.index(where: { $0 == item }), let team = teamsInfo.teams.element(at: index) {
            return team
        }
        return nil
    }
}
