//
//  IssueDetailsView.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 03/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct IssueDetailsViewData {

}

final class IssueDetailsView: NSView {
    private let scrollView = NSScrollView()

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(scrollView)
        scrollView.constraintEdgesToSuperview()
        let containerView = NSView()
        scrollView.addSubview(containerView)
        containerView.constraintEdgesToSuperview()

        let empty = NSGridCell.emptyContentView

        let gridView = NSGridView(views: [
            [labelWithText(text: "BM-1656"), empty],
            [labelWithText(text: "Task do zrobienia blDNKJASDHKjhdkjaHSKjhskjaHSKJSAHKJhskjaHS"), empty],
            [labelWithText(text: "Status"), labelWithText(text: "None")],
            [labelWithText(text: "Status"), labelWithText(text: "None")],
            [labelWithText(text: "Status"), labelWithText(text: "None")]
            ])

        containerView.addSubview(gridView)
        gridView.leadingToSuperview()
        gridView.topToSuperview()
        gridView.trailingToSuperview()
        gridView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor).activate()
    }

    private func labelWithText(text: String) -> NSTextField {
        let field = NSTextField()
        TextFieldStyles.nonEditableStandardLabel.apply(to: field)
        field.stringValue = text
        return field
    }
}
