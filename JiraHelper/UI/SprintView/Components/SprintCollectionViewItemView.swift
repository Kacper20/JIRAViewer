//
//  SprintCollectionViewItemView.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 24/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift
import AppKit
import WebKit

final class SprintCollectionViewItemView: NSView {


    private let itemNameLabel = NSTextField()
    private let itemLabels = NSTextField()
    private let itemKeyLabel = NSTextField()

    private let itemColorView = NSView()

    private let typeWebView = WKWebView()
    private let priorityImageView = NSImageView()
    private let assigneeImageView = NSImageView()

    private let doubleClickedSubject = PublishSubject<Void>()

    var doubleClicked: Observable<Void> {
        return doubleClickedSubject
    }

    init() {
        super.init(frame: .zero)
        setupStyle()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        //TODO: Styles?
        itemColorView.wantsLayer = true
        itemColorView.layer?.backgroundColor = #colorLiteral(red: 0.9599999785, green: 0.5799999833, blue: 0.25, alpha: 1).cgColor
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor
        layer?.cornerRadius = SprintViewsConfiguration.cornerRadius
        setSelection(false)
        itemNameLabel.cell?.wraps = true
        itemNameLabel.maximumNumberOfLines = 0
        TextFieldStyles.nonEditableStandardLabel.apply(to: itemNameLabel, itemLabels, itemKeyLabel)
        TextFieldStyles.grayFootnote.apply(to: itemKeyLabel)
        layer?.masksToBounds = false
        layer?.shadowOffset = CGSize(width: 0, height: 1)
        layer?.shadowRadius = 2.0
        layer?.shadowOpacity = 0.3
    }

    func clearContents() {
        itemLabels.stringValue = ""
        assigneeImageView.image = nil
    }

    private func setupConstraints() {
        addSubview(itemColorView)
        translatesAutoresizingMaskIntoConstraints = false
        itemColorView.widthAnchor.constraint(equalToConstant: 4).activate()
        itemColorView.leadingToSuperview()
        itemColorView.topToSuperview()
        itemColorView.bottomToSuperview()

        let itemsStackView = NSStackView()
        addSubview(itemsStackView)
        itemsStackView.widthAnchor.constraint(equalToConstant: 120).activate()
        itemsStackView.spacing = 4
        itemsStackView.distribution = .fillProportionally
        itemsStackView.alignment = .leading
        let itemsStackViewSideOffset: CGFloat = 4
        itemsStackView.leadingAnchor.constraint(
            equalTo: itemColorView.trailingAnchor, constant: itemsStackViewSideOffset
        ).activate()
        itemsStackView.topToSuperview(with: 4.0)
        itemsStackView.bottomToSuperview(with: -4.0)
        itemsStackView.trailingToSuperview(with: -4.0)
        itemsStackView.orientation = .vertical
        let imagesStackView = NSStackView()
        imagesStackView.orientation = .horizontal
        imagesStackView.distribution = .fillEqually
        let imageSize: CGFloat = 24
        imagesStackView.addArrangedSubviews(typeWebView, priorityImageView, assigneeImageView)
        setupIconView(assigneeImageView, size: imageSize)
        setupIconView(typeWebView, size: imageSize)
        setupIconView(priorityImageView, size: imageSize)
        assigneeImageView.layer?.cornerRadius = imageSize / 2

        itemsStackView.addArrangedSubviews(itemNameLabel, itemLabels, imagesStackView, itemKeyLabel)
    }

    private func setupIconView(_ view: NSView, size: CGFloat) {
        view.wantsLayer = true
        view.widthAnchor.constraint(equalToConstant: size).activate()
        view.heightAnchor.constraint(equalToConstant: size).activate()
        view.topToSuperview()
        view.bottomToSuperview()
    }


    func setSelection(_ isSelected: Bool) {
        let color: NSColor
        let width: CGFloat
        if isSelected {
            color = #colorLiteral(red: 0.9200000167, green: 0.9499999881, blue: 0.9700000286, alpha: 1)
            width = 4.0
        } else {
            color = NSColor.lightGray
            width = 1.0
        }
        layer?.borderColor = color.cgColor
        layer?.borderWidth = width
    }

    override func mouseDown(with event: NSEvent) {
        if event.clickCount == 2 {
            doubleClickedSubject.onNext(())
        }
        super.mouseDown(with: event)
    }

    var assigneeImageSink: AnyObserver<NSImage> {
        return AnyObserver<NSImage>.next { [weak self] in self?.assigneeImageView.image = $0 }
    }

    var typeURLSink: AnyObserver<URL> {
        return AnyObserver<URL>.next { [weak self] url in
            let request = URLRequest(url: url)
            self?.typeWebView.load(request)
        }
    }

    var priorityImageSink: AnyObserver<NSImage> {
        return AnyObserver<NSImage>.next { [weak self] in self?.priorityImageView.image = $0 }
    }

    func update(with data: SprintElementData) {
        itemNameLabel.stringValue = data.title
        itemLabels.stringValue = data.labels
        itemKeyLabel.stringValue = data.key
    }
}
