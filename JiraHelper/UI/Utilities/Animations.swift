//
//  Animations.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 04/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import AppKit

struct Animation {

    static func animate(with duration: TimeInterval, animations: () -> Void, completion: (() -> Void)? = nil) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = duration
            animations()
        }, completionHandler: completion)
    }
}
