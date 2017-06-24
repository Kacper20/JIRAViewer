//
//  View+Extensions.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 24/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

extension NSStackView {
    func addArrangedSubviews(_ subviews: NSView...) {
        subviews.forEach { self.addArrangedSubview($0) }
    }
}
