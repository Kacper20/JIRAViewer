//
//  TextFieldStyles.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17.02.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct TextFieldStyles {
    static var mainInput: NSViewStyle<NSTextField> {
        return NSViewStyle { textField in
            textField.maximumNumberOfLines = 1
            textField.cell?.wraps = false
            textField.cell?.isScrollable = true
            textField.layer?.cornerRadius = 6.0
            textField.focusRingType = .none
        }
    }

    static var grayFootnote: NSViewStyle<NSTextField> {
        return NSViewStyle { textField in
            textField.textColor = NSColor.lightGray
        }
    }

    static var headline: NSViewStyle<NSTextField> {
        return NSViewStyle { textField in
            textField.font = NSFont.boldSystemFont(ofSize: 16)
        }
    }

    static var sectionHeadline: NSViewStyle<NSTextField> {
        return NSViewStyle { textField in
            textField.font = NSFont.boldSystemFont(ofSize: 14)
        }
    }

    static var nonEditableStandardLabel: NSViewStyle<NSTextField> {
        return NSViewStyle { textField in
            textField.drawsBackground = false
            textField.isEditable = false
            textField.isBordered = false
            textField.alignment = .left
        }
    }
}

extension NSTextField {
    convenience init(styles: NSViewStyle<NSTextField>...) {
        self.init(frame: .zero)
        styles.forEach { $0.apply(to: self) }
    }
}
