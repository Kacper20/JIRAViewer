//
//  BoardChoiceToolbarItemProvider.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//
import Foundation
import RxSwift

final class PopupButtonToolbarItemManager {

    var item: NSToolbarItem!
    let identifier: String
    private let button: NSPopUpButton
    private let buttonSelectionSubject = PublishSubject<Int>()

    var selectionChanges: Observable<Int> {
        return buttonSelectionSubject
    }

    init(identifier: String, texts: [String], selectedIndex: Int) {
        self.identifier = identifier
        let button = NSPopUpButton()
        self.button = button
        button.addItems(withTitles: texts)
        button.selectItem(at: selectedIndex)
        button.sizeToFit()
        button.target = self
        button.action = #selector(PopupButtonToolbarItemManager.buttonOptionChanged)

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

    @objc private func buttonOptionChanged() {
        buttonSelectionSubject.onNext(button.indexOfSelectedItem)
    }

    @objc private func targetAction() { }
}
