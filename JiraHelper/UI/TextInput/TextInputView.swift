//
//  TextInputView.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16.02.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import AppKit

final class TextInputView: NSView {
    private let textField = NSTextField()

    override init(frame frameRect: NSRect) {
        super.init(frame: .zero)

        setupStyle()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        textField.backgroundColor = .blue
        textField.isEditable = true
        textField.isSelectable = true
        textField.placeholderString = "Searching JIRA"
    }

    private func setupConstraints() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
