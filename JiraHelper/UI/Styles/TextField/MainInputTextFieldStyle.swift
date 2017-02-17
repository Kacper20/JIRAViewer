//
//  MainInputTextFieldStyle.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17.02.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct MainInputTextFieldStyle {
    static func create() -> NSViewStyle<NSTextField> {
        return NSViewStyle { textField in
            textField.backgroundColor = .white
        }
    }
}
