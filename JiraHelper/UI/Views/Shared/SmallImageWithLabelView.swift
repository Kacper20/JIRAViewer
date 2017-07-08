//
//  ImageWithLabelView.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 08/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class SmallImageWithLabelView: NSView {

    private let imageView = NSImageView()
    private let label = NSTextField()

    var imageSink: AnyObserver<NSImage> {
        return AnyObserver<NSImage>.next { [weak self] in self?.imageView.image = $0 }
    }

    init(text: String) {
        super.init(frame: .zero)
        setupStyle()
        setupConstraints()
        label.stringValue = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        TextFieldStyles.nonEditableStandardLabel.apply(to: label)
        imageView.wantsLayer = true
    }

    private func setupConstraints() {
        let stackView = NSStackView()
        addSubview(stackView)
        stackView.constraintEdgesToSuperview()
        stackView.orientation = .horizontal
        stackView.addArrangedSubviews(imageView, label)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 24).activate()
        imageView.widthAnchor.constraint(equalToConstant: 24).activate()
        imageView.layer?.cornerRadius = 2.0
        label.maximumNumberOfLines = 1
    }
}
