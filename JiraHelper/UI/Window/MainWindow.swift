//
//  MainWindow.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16.02.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import AppKit

final class MainWindow: NSWindow {

    let view = NSView()

    override var canBecomeKey: Bool {
        return true
    }
    override init(contentRect: NSRect, styleMask style: NSWindowStyleMask, backing bufferingType: NSBackingStoreType, defer flag: Bool) {

        super.init(contentRect: contentRect, styleMask: style, backing: bufferingType, defer: flag)
        self.isMovable = false
        self.contentView = view
        view.wantsLayer = true
        self.isOpaque = false
        self.backgroundColor = NSColor.clear

    }
}
