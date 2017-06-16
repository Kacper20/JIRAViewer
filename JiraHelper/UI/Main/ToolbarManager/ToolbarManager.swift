//
//  ToolbarManager.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

@objc class ToolbarManager: NSObject, NSToolbarDelegate {

    private let boardChoiceToolbarItemID = "boardChoice"
    private let sprintChoiceToolbarItemID = "sprintChoice"

    private let boardChoiceToolbarItemManager: PopupButtonToolbarItemManager
        private let sprintChoiceToolbarItemManager: PopupButtonToolbarItemManager

    private let boardsChoice: BoardsChoice
    private let sprintChoice: ActiveSprintChoice
    private let toolbar: NSToolbar

    init(toolbar: NSToolbar, boardsChoice: BoardsChoice, sprintChoice: ActiveSprintChoice) {
        self.boardsChoice = boardsChoice
        self.sprintChoice = sprintChoice
        self.toolbar = toolbar
        boardChoiceToolbarItemManager = PopupButtonToolbarItemManager(
            identifier: boardChoiceToolbarItemID,
            texts: boardsChoice.texts,
            selectedIndex: 0
        )
        sprintChoiceToolbarItemManager = PopupButtonToolbarItemManager(
            identifier: sprintChoiceToolbarItemID,
            texts: sprintChoice.texts,
            selectedIndex: 0
        )
        super.init()
        toolbar.delegate = self
        toolbar.insertItem(withItemIdentifier: boardChoiceToolbarItemManager.identifier, at: 0)
        toolbar.insertItem(withItemIdentifier: sprintChoiceToolbarItemManager.identifier, at: 1)
        toolbar.insertItem(withItemIdentifier: NSToolbarFlexibleSpaceItemIdentifier, at: 2)
    }

    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: String,
        willBeInsertedIntoToolbar flag: Bool
        ) -> NSToolbarItem? {
        switch itemIdentifier {
        case boardChoiceToolbarItemID:
            return boardChoiceToolbarItemManager.item
        case sprintChoiceToolbarItemID:
            return sprintChoiceToolbarItemManager.item
        default:
            return nil
        }
    }
}
