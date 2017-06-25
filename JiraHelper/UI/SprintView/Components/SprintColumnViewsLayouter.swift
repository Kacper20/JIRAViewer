//
//  SprintColumnsViewManager.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 25/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class ColumnDescriptionView: NSView {

    private let titleLabel = NSTextField()

    init(title: String) {
        super.init(frame: .zero)
        setupConstraints()
        setupStyle()
        titleLabel.stringValue = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        TextFieldStyles.nonEditableSprintItemLabel.apply(to: titleLabel)
        TextFieldStyles.headline.apply(to: titleLabel)
    }

    private func setupConstraints() {
        addSubview(titleLabel)
        titleLabel.constraintEdgesToSuperview(with: NSEdgeInsets(top: 0, left: 0, bottom: 4, right: 0))
    }
}

typealias OffsetWithSize = (offset: CGFloat, size: CGFloat)

struct ColumnsLayoutInformation {
    let offsetValue: CGFloat
    let names: [String]
}

struct SprintColumnViewsLayouter {
    private let stackView: NSStackView
    private let layoutInfo: ColumnsLayoutInformation

    init(stackView: NSStackView, layoutInfo: ColumnsLayoutInformation ) {
        self.stackView = stackView
        self.layoutInfo = layoutInfo
    }

    func layout() {
        stackView.orientation = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = layoutInfo.offsetValue
        let subviews = layoutInfo.names.map(ColumnDescriptionView.init)
        subviews.forEach { stackView.addArrangedSubview($0) }
    }
}
