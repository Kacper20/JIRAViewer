//
//  SprintCollectionViewItem.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 06.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Cocoa
import AppKit

final class SprintCollectionViewItem: NSCollectionViewItem {

    @IBOutlet weak var itemNameField: NSTextField!
    @IBOutlet weak var itemTypeView: NSView!


    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.cornerRadius = 4.0
        view.layer?.borderColor = NSColor.lightGray.cgColor
        view.layer?.borderWidth = 1.0

        itemTypeView.wantsLayer = true
        itemTypeView.layer?.backgroundColor = NSColor.red.cgColor
    }
}

extension SprintCollectionViewItem {
    static var identifier: String {
        return String(describing: self)
    }
}


