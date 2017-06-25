//
//  NSView+Constraints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

extension NSView {

    private var forcedSuperview: NSView {
        guard let superView = superview else { fatalError("View should have a superview before adding constraint") }
        return superView
    }

    private func doNotTranslateMasks() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    func constraintEdges(to anotherView: NSView, with insets: NSEdgeInsets = NSEdgeInsetsZero) {
        doNotTranslateMasks()
        leftAnchor.constraint(equalTo: anotherView.leftAnchor, constant: insets.left).activate()
        topAnchor.constraint(equalTo: anotherView.topAnchor, constant: insets.top).activate()
        rightAnchor.constraint(equalTo: anotherView.rightAnchor, constant: -insets.right).activate()
        bottomAnchor.constraint(equalTo: anotherView.bottomAnchor, constant: -insets.bottom).activate()
    }

    func constraintEdgesToSuperview(with insets: NSEdgeInsets = NSEdgeInsetsZero) {
        constraintEdges(to: forcedSuperview, with: insets)
    }

    func topToSuperview(with constant: CGFloat = 0.0) {
        doNotTranslateMasks()
        topAnchor.constraint(equalTo: forcedSuperview.topAnchor, constant: constant).activate()
    }

    func bottomToSuperview(with constant: CGFloat = 0.0) {
        doNotTranslateMasks()
        bottomAnchor.constraint(equalTo: forcedSuperview.bottomAnchor, constant: constant).activate()
    }

    func leadingToSuperview(with constant: CGFloat = 0.0) {
        doNotTranslateMasks()
        leadingAnchor.constraint(equalTo: forcedSuperview.leadingAnchor, constant: constant).activate()
    }

    func trailingToSuperview(with constant: CGFloat = 0.0) {
        doNotTranslateMasks()
        trailingAnchor.constraint(equalTo: forcedSuperview.trailingAnchor, constant: constant).activate()
    }

    func constraintWithSuperview(_ constraintBuilder: (NSView, NSView) -> Void) {
        doNotTranslateMasks()
        constraintBuilder(self, forcedSuperview)
    }
}

extension NSLayoutConstraint {
    func activate() {
        isActive = true
    }
}
