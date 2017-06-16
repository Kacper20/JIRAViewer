//
//  BoardChoiceToolbarItemProvider.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class PopupButtonToolbarItemManager {

    var item: NSToolbarItem!
    let identifier: String

    init(identifier: String, texts: [String], selectedIndex: Int) {
        self.identifier = identifier
        let button = NSPopUpButton()
        button.addItems(withTitles: texts)
        button.selectItem(at: selectedIndex)
        button.sizeToFit()

        item = ToolbarItemProvider.customToolbarItem(
            itemForItemIdentifier: identifier,
            label: "",
            paletteLabel: "",
            toolTip: "",
            target: self,
            itemContentType: .customView(button),
            action: #selector(PopupButtonToolbarItemManager.targetAction),
            menu: nil
        ) ?? NSToolbarItem()
    }

    @objc private func targetAction() { }
}
