//
//  ToolbarManager.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

fileprivate extension NSTouchBarItemIdentifier {
    static let sprintPopover = NSTouchBarItemIdentifier("com.ToolbarSample.TouchBarItem.popover")
}

//TODO: Consider splitting these two classes
@objc class MainWindowToolbarManager: NSObject, NSToolbarDelegate, NSTouchBarDelegate {

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
        configureToolbarContent()
    }

    @available(OSX 10.12.2, *)
    func setupTouchBar(touchBar: NSTouchBar) {
        touchBar.delegate = self
        if !sprintChoice.rest.isEmpty {
            touchBar.defaultItemIdentifiers = [.sprintPopover]
        }
    }

    @available(OSX 10.12.2, *)
    func touchBar(
        _ touchBar: NSTouchBar,
        makeItemForIdentifier identifier: NSTouchBarItemIdentifier
        ) -> NSTouchBarItem? {
        switch identifier {
        case .sprintPopover:
            let popoverItem = NSPopoverTouchBarItem(identifier: identifier)
            //TODO: Localization
            popoverItem.collapsedRepresentationLabel = sprintChoice.selected.name
            return popoverItem
        default:
            return nil
        }
    }

    private func configureToolbarContent() {
        toolbar.delegate = self
        if !boardsChoice.rest.isEmpty {
            appendItem(to: toolbar, withItemIdentifier: boardChoiceToolbarItemManager.identifier)
        }
        if !sprintChoice.rest.isEmpty {
            appendItem(to: toolbar, withItemIdentifier: sprintChoiceToolbarItemManager.identifier)
        }
        appendItem(to: toolbar, withItemIdentifier: NSToolbarFlexibleSpaceItemIdentifier)
    }

    private func appendItem(to toolbar: NSToolbar, withItemIdentifier identifier: String) {
        toolbar.insertItem(withItemIdentifier: identifier, at: toolbar.items.count)
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
