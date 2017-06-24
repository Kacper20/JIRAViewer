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

final class SprintCollectionViewItemView: NSView {

    private let stackView = NSStackView()

    private let itemNameLabel = NSTextField()
    private let itemLabels = NSTextField()
    private let itemKeyLabel = NSTextField()

    private let assigneeImageView = NSImageView()

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
        wantsLayer = true
        layer?.cornerRadius = 4.0
        layer?.borderColor = NSColor.lightGray.cgColor
        layer?.borderWidth = 1.0
        itemNameLabel.cell?.wraps = true
        itemNameLabel.maximumNumberOfLines = 0
        TextFieldStyles.nonEditableSprintItemLabel.apply(to: itemNameLabel, itemLabels, itemKeyLabel)
    }

    private func setupConstraints() {
//        addSubview(itemNameLabel)
//        itemNameLabel.constraintEdges(to: self)
//        itemNameLabel.widthAnchor.constraint(equalToConstant: 100).activate()
        addSubview(stackView)
        stackView.widthAnchor.constraint(equalToConstant: 100).activate()
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.constraintEdges(to: self)
        stackView.orientation = .vertical
        stackView.addArrangedSubviews(itemNameLabel, itemLabels, assigneeImageView, itemKeyLabel)

        assigneeImageView.widthAnchor.constraint(equalToConstant: 32).activate()
        assigneeImageView.heightAnchor.constraint(equalTo: assigneeImageView.widthAnchor, multiplier: 0).activate()
    }

    var imageSink: AnyObserver<NSImage> {
        return AnyObserver<NSImage>.next { [weak self] in self?.assigneeImageView.image = $0 }
    }

    func update(with data: SprintElementData) {
        itemNameLabel.stringValue = data.title
        itemLabels.stringValue = data.labels
        itemKeyLabel.stringValue = data.key
    }
}
