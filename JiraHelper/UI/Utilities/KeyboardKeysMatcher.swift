//
//  KeyboardKeysMatcher.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum KeyCode: Int {
    case i = 34
}

struct KeysMatcher {
    static func match(code: KeyCode, in event: NSEvent) -> Bool {
        return event.keyCode == code.rawValue
    }
}
