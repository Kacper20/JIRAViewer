//
//  CommentView.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 15/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class CommentView: NSView {

    private let data: IssueDetailsCommentData

    init(data: IssueDetailsCommentData) {
        self.data = data
        super.init(frame: .zero)
        setupConstraints()
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        addSubview(stackView)
        stackView.constraintEdgesToSuperview()
        let authorAndDateLabel = NSTextField(styles: TextFieldStyles.nonEditableStandardLabel)
        authorAndDateLabel.stringValue = "\(data.author) added a comment - \(data.date)"

        let bodyLabel = NSTextField(styles: TextFieldStyles.nonEditableStandardLabel)
        bodyLabel.setHtml(data.body, fontSize: 13)
        stackView.addArrangedSubviews(authorAndDateLabel, bodyLabel)

        authorAndDateLabel.leadingToSuperview()
        authorAndDateLabel.trailingToSuperview()
        bodyLabel.leadingToSuperview(with: 4)
        bodyLabel.trailingToSuperview()
    }
}
