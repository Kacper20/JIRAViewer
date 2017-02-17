//
//  StylingProtocol.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17.02.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import AppKit

struct NSViewStyle<T: NSView> {

    let styling: (T)-> Void

    static func compose(_ styles: NSViewStyle<T>...)-> NSViewStyle<T> {

        return NSViewStyle { view in
            for style in styles {
                style.styling(view)
            }
        }
    }

    func apply(to view: T) {
        styling(view)
    }
}
