//
//  GradientOverlayView.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class GradientOverlayEnricher {

    static func setupGradient(on view: NSView) {
        let gradientLayer = CAGradientLayer()
        view.wantsLayer = true
        gradientLayer.colors = [
            NSColor.white.cgColor,
            NSColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer?.mask = gradientLayer
    }
}
