//
//  MaskImage.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17.02.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct MaskImage {
    static func create(withRadius cornerRadius: CGFloat) -> NSImage {
        let edgeLength = 2.0 * cornerRadius + 1.0
        let maskImage = NSImage(size: NSSize(width: edgeLength, height: edgeLength), flipped: false) { rect in
            let bezierPath = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)

            NSColor.black.set()
            bezierPath.fill()
            return true
        }
        maskImage.capInsets = EdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius)
        maskImage.resizingMode = .stretch
        return maskImage
    }
}
