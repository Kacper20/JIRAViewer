//
//  NSView+Constraints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

extension NSView {
    func constraintEdges(to anotherView: NSView, with insets: NSEdgeInsets = NSEdgeInsetsZero) {
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: anotherView.leftAnchor, constant: insets.left).isActive = true
        topAnchor.constraint(equalTo: anotherView.topAnchor, constant: insets.top).isActive = true
        rightAnchor.constraint(equalTo: anotherView.rightAnchor, constant: -insets.right).isActive = true
        bottomAnchor.constraint(equalTo: anotherView.bottomAnchor, constant: -insets.bottom).isActive = true
    }

    func constraintEdgesToSuperview(with insets: NSEdgeInsets = NSEdgeInsetsZero) {
        guard let superView = superview else { fatalError("View should have a superview before adding constraint") }
        constraintEdges(to: superView, with: insets)
    }

    func constraintWithSuperview(_ constraintBuilder: (NSView, NSView) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let parent = superview else { fatalError("View should have a superview before adding constraint") }
        constraintBuilder(self, parent)
    }
}

extension NSLayoutConstraint {
    func activate() {
        isActive = true
    }
}
