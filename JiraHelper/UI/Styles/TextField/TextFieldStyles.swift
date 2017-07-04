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
            textField.isBordered = false
            textField.maximumNumberOfLines = 1
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

    static var nonEditableStandardLabel: NSViewStyle<NSTextField> {
        return NSViewStyle { textField in
            textField.isEditable = false
            textField.isBordered = false
            textField.alignment = .left
        }
    }
}
