//
//  IssueDetailsView.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 03/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//
import Foundation
import RxSwift

final class IssueDetailsView: NSView {
    private let scrollView = NSScrollView()
    private let data: IssueDetailsViewData
    private let urlImageConversion: URLImageConversion
    private let disposeBag = DisposeBag()

    init(data: IssueDetailsViewData, urlImageConversion: @escaping URLImageConversion) {
        self.urlImageConversion = urlImageConversion
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

        let personViews = data.peopleInvolved.map { person -> [NSView] in
            let label = labelWithText(text: person.role)
            let view = SmallImageWithLabelView(text: person.name)
            let image = self.urlImageConversion(person.avatarUrl)
            image.bind(to: view.imageSink).disposed(by: disposeBag)
            return [label, view]
        }
        var views: [[NSView]] = [
            [labelWithText(text: data.keyName, styles: TextFieldStyles.headline), empty],
            [labelWithText(text: data.title), empty],
            [labelWithText(text: "Details", styles: TextFieldStyles.sectionHeadline), empty],
            [labelWithText(text: "Status"), labelWithText(text: "None")],
            [labelWithText(text: "Status"), labelWithText(text: "None")],
            [labelWithText(text: "Status"), labelWithText(text: "None")],
            [labelWithText(text: "People", styles: TextFieldStyles.sectionHeadline), empty]
        ]
        views.append(contentsOf: personViews)
        views.append(contentsOf: [
            [labelWithText(text: "Dates", styles: TextFieldStyles.sectionHeadline), empty],
            [labelWithText(text: "Created:"), labelWithText(text: data.creationTime)],
            [labelWithText(text: "Last Viewed:"), labelWithText(text: data.lastViewTime ?? "Never")],
        ])

        views.append([labelWithText(text: "Description", styles: TextFieldStyles.sectionHeadline)])
        views.append([attributedLabel(html: data.descriptionHtml)])

        let gridView = NSGridView(views: views)

        containerView.addSubview(gridView)
        gridView.leadingToSuperview()
        gridView.topToSuperview()
        gridView.trailingToSuperview()
        gridView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor).activate()
    }

    private func attributedLabel(html: String) -> NSTextField {
        let field = NSTextField()
        TextFieldStyles.nonEditableStandardLabel.apply(to: field)
        guard let data = html.data(using: .utf16) else { return field }
        let attributedString = try? NSAttributedString(
            data: data,
            options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType],
            documentAttributes: nil
        )
        if let attrString = attributedString {
            field.attributedStringValue = attrString
        }
        return field
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
