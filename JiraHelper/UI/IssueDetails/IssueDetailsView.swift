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
    private let data: IssueDetailsViewData
    private let urlImageConversion: URLImageConversion
    private let disposeBag = DisposeBag()

    private let scrollViewContainer = NSView()
    private let gradientLayer = CAGradientLayer()


    init(data: IssueDetailsViewData, urlImageConversion: @escaping URLImageConversion) {
        self.urlImageConversion = urlImageConversion
        self.data = data
        super.init(frame: .zero)
        setupViews()
        setupGradient()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {
        super.layout()
        gradientLayer.frame = scrollViewContainer.bounds
    }

    private func setupGradient() {
        scrollViewContainer.wantsLayer = true
        gradientLayer.colors = [
            NSColor.clear.cgColor,
            NSColor.white.cgColor,
            NSColor.white.cgColor
        ]
        gradientLayer.locations = [0, 0.03, 0.05]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        scrollViewContainer.layer?.mask = gradientLayer
    }

    private func setupViews() {

        let keyLabel = labelWithText(text: data.keyName, styles: TextFieldStyles.headline)
        let summaryLabel = labelWithText(text: data.title)

        addSubviews(keyLabel, summaryLabel)
        let inset: CGFloat = 8
        keyLabel.topToSuperview(with: 24)
        keyLabel.leadingToSuperview(with: inset)
        keyLabel.trailingToSuperview(with: -inset)

        summaryLabel.topAnchor.constraint(equalTo: keyLabel.bottomAnchor, constant: inset).activate()
        summaryLabel.leadingToSuperview(with: inset)
        summaryLabel.trailingToSuperview(with: -inset)

        addSubview(scrollViewContainer)
        scrollViewContainer.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: inset).activate()
        scrollViewContainer.leadingToSuperview(with: inset)
        scrollViewContainer.trailingToSuperview(with: -inset)
        scrollViewContainer.bottomToSuperview(with: -inset)

        let scrollView = NSScrollView()
        scrollViewContainer.addSubview(scrollView)
        scrollView.constraintEdgesToSuperview()
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false
        scrollViewContainer.addSubview(scrollView)

        let containerView = NSView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView = containerView

        let gridView = viewsGrid()
        let stackView = underGridStackView()

        containerView.addSubviews(gridView, stackView)
        containerView.topToSuperview()
        containerView.leadingToSuperview()
        containerView.trailingToSuperview()
        gridView.leadingToSuperview()
        gridView.topToSuperview(with: 4)
        gridView.trailingToSuperview()

        stackView.topAnchor.constraint(equalTo: gridView.bottomAnchor, constant: inset).activate()
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
        let descriptionBody = attributedLabel(with: data.descriptionHtml, fontSize: 12)
        let descriptionViews = [descriptionHeadline, descriptionBody]
        let commentViews = createCommentViews()
        let allViews: [NSView] = descriptionViews + commentViews
        stackView.addArrangedSubviews(allViews)
        allViews.forEach {
            $0.leadingToSuperview()
            $0.trailingToSuperview()
        }
        return stackView
    }

    private func createCommentViews() -> [NSView] {
        var views = [NSView]()
        views.append(labelWithText(text: "Comments", styles: TextFieldStyles.headline))
        let commentViews = data.comments.flatMap(CommentView.init(data: ))
        if commentViews.isEmpty {
            views.append(labelWithText(text: "No comments", styles: TextFieldStyles.headline))
        }

        return views + commentViews
    }

    private func attributedLabel(with html: String, fontSize: CGFloat) -> NSTextField {
        let field = NSTextField()
        TextFieldStyles.nonEditableStandardLabel.apply(to: field)
        field.setHtml(html, fontSize: fontSize)
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
