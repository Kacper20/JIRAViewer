//
//  SprintColumnDecorationView.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 02/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class SprintColumnDecorationView: NSView {

    static var identifier: String {
        return String(describing: SprintColumnDecorationView.self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        wantsLayer = true
        layer?.backgroundColor = #colorLiteral(red: 0.9599999785, green: 0.9599999785, blue: 0.9599999785, alpha: 1).cgColor
        layer?.cornerRadius = SprintViewsConfiguration.cornerRadius
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
