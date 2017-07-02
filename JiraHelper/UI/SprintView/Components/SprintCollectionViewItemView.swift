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


    private let itemNameLabel = NSTextField()
    private let itemLabels = NSTextField()
    private let itemKeyLabel = NSTextField()

    private let itemColorView = NSView()

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
        itemColorView.wantsLayer = true
        itemColorView.layer?.backgroundColor = #colorLiteral(red: 0.9599999785, green: 0.5799999833, blue: 0.25, alpha: 1).cgColor
        wantsLayer = true
        layer?.cornerRadius = 4.0
        setSelection(false)
        itemNameLabel.cell?.wraps = true
        itemNameLabel.maximumNumberOfLines = 0
        TextFieldStyles.nonEditableSprintItemLabel.apply(to: itemNameLabel, itemLabels, itemKeyLabel)
        TextFieldStyles.grayFootnote.apply(to: itemKeyLabel)
    }

    func clearContents() {
        itemLabels.stringValue = ""
        assigneeImageView.image = nil
    }

    private func setupConstraints() {
        addSubview(itemColorView)
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
        itemsStackView.addArrangedSubviews(itemNameLabel, itemLabels, assigneeImageView, itemKeyLabel)

        let imageSize: CGFloat = 24
        assigneeImageView.widthAnchor.constraint(equalToConstant: imageSize).activate()
        assigneeImageView.heightAnchor.constraint(equalToConstant: imageSize).activate()
        assigneeImageView.layer?.cornerRadius = imageSize / 2
    }

    func setSelection(_ isSelected: Bool) {
        let color: NSColor
        let width: CGFloat
        if isSelected {
            color = NSColor.blue
            width = 4.0
        } else {
            color = NSColor.lightGray
            width = 1.0
        }
        layer?.borderColor = color.cgColor
        layer?.borderWidth = width
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
