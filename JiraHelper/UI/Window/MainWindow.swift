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
        self.contentView = view
        self.isOpaque = true
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.cgColor
        view.layer?.cornerRadius = 20

    }
}
