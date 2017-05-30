//
//  CheckMarkView.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import AppKit

final class CheckMarkView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        JIRASpotlightStyleKit.drawCheckMark(frame: dirtyRect)
    }
}
