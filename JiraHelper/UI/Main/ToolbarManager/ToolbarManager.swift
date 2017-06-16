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

    private let boardChoiceToolbarItemManager: BoardChoiceToolbarItemManager

    private let boardsChoice: BoardsChoice
    private let toolbar: NSToolbar

    init(toolbar: NSToolbar, boardsChoice: BoardsChoice) {
        self.boardsChoice = boardsChoice
        self.toolbar = toolbar
        boardChoiceToolbarItemManager = BoardChoiceToolbarItemManager(
            identifier: boardChoiceToolbarItemID,
            texts: boardsChoice.texts,
            selectedIndex: 0
        )
        super.init()
        toolbar.delegate = self
        toolbar.insertItem(withItemIdentifier: boardChoiceToolbarItemID, at: 0)
        toolbar.insertItem(withItemIdentifier: NSToolbarFlexibleSpaceItemIdentifier, at: 1)
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
            return boardChoiceToolbarItemManager.item
        default:
            return nil
        }
    }
}
