//
//  IssueDetailsView.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 03/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class IssueDetailsView: NSView {
    private let scrollView = NSScrollView()
    private let data: IssueDetailsViewData

    init(data: IssueDetailsViewData) {
        self.data = data
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
        let inset: CGFloat = 8
        containerView.constraintEdgesToSuperview(with: NSEdgeInsets(
            top: inset, left: inset, bottom: inset, right: inset)
        )

        let empty = NSGridCell.emptyContentView

        let gridView = NSGridView(views: [
            [labelWithText(text: data.keyName, styles: TextFieldStyles.headline), empty],
            [labelWithText(text: data.title), empty],
            [labelWithText(text: "Details", styles: TextFieldStyles.sectionHeadline), empty],
            [labelWithText(text: "Status"), labelWithText(text: "None")],
            [labelWithText(text: "Status"), labelWithText(text: "None")],
            [labelWithText(text: "Status"), labelWithText(text: "None")],
            [labelWithText(text: "People", styles: TextFieldStyles.sectionHeadline), empty],
            [labelWithText(text: "Dates", styles: TextFieldStyles.sectionHeadline), empty],
            [labelWithText(text: "Created:"), labelWithText(text: data.creationTime)],
            [labelWithText(text: "Last Viewed:"), labelWithText(text: data.lastViewTime ?? "Never")],
            ])

        containerView.addSubview(gridView)
        gridView.leadingToSuperview()
        gridView.topToSuperview()
        gridView.trailingToSuperview()
        gridView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor).activate()
    }

    private func labelWithText(text: String, styles: NSViewStyle<NSTextField>...) -> NSTextField {
        let field = NSTextField()
        TextFieldStyles.nonEditableStandardLabel.apply(to: field)
        for style in styles {
            style.apply(to: field)
        }
        field.stringValue = text
        return field
    }
}
