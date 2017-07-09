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

        let keyLabel = labelWithText(text: data.keyName, styles: TextFieldStyles.headline)
        let summaryLabel = labelWithText(text: data.title)
        let containerView = NSView()
        scrollView.addSubviews(containerView, keyLabel, summaryLabel)

        let inset: CGFloat = 8
        keyLabel.topToSuperview(with: inset)
        keyLabel.leadingToSuperview(with: inset)
        keyLabel.trailingToSuperview(with: -inset)

        summaryLabel.topAnchor.constraint(equalTo: keyLabel.bottomAnchor, constant: inset).activate()
        summaryLabel.leadingToSuperview(with: inset)
        summaryLabel.trailingToSuperview(with: -inset)

        containerView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: inset).activate()
        containerView.leadingToSuperview(with: inset)
        containerView.trailingToSuperview(with: -inset)
        containerView.bottomToSuperview(with: -inset)

        let gridView = viewsGrid()
        let stackView = underGridStackView()

        containerView.addSubviews(gridView, stackView)
        gridView.leadingToSuperview()
        gridView.topToSuperview()
        gridView.trailingToSuperview()

        stackView.topAnchor.constraint(equalTo: gridView.bottomAnchor, constant: inset)
        stackView.leadingToSuperview()
        stackView.trailingToSuperview()
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor).activate()
    }


    private func viewsGrid() -> NSGridView{
        let empty = NSGridCell.emptyContentView
        let personViews = data.peopleInvolved.map { person -> [NSView] in
            let label = labelWithText(text: person.role)
            let view = SmallImageWithLabelView(text: person.name)
            let image = self.urlImageConversion(person.avatarUrl)
            image.bind(to: view.imageSink).disposed(by: disposeBag)
            return [label, view]
        }
        var views: [[NSView]] = [
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
        return NSGridView(views: views)
    }

    private func underGridStackView() -> NSStackView {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        let descriptionHeadline = labelWithText(text: "Description", styles: TextFieldStyles.sectionHeadline)
//        let descriptionBody = attributedTextView(html: data.descriptionHtml)
        let descriptionBody = labelWithText(text: data.descriptionHtml)
        let views = [descriptionHeadline, descriptionBody]
        stackView.addArrangedSubviews(views)
        views.forEach {
            $0.leadingToSuperview()
            $0.trailingToSuperview()
        }
        return stackView
    }

    private func commentViews() -> [NSView] {
        var views = [NSView]()
        views.append(labelWithText(text: "Comments", styles: TextFieldStyles.headline))
        return views
    }

    private func attributedTextView(html: String) -> NSTextView {
        let view = NSTextView()
        let font = NSFont.systemFont(ofSize: 13)
        guard let data = html.data(using: .utf16) else { return view }
        let attributedString = try? NSAttributedString(
            data: data,
            options: [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSFontAttributeName: font
            ],
            documentAttributes: nil
        )
        if let attrString = attributedString {
            view.textStorage?.append(attrString)
        }
        return view
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
