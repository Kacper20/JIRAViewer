//
//  SprintCollectionViewItem.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 06.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Cocoa
import AppKit
import RxSwift

final class SprintCollectionViewItem: NSCollectionViewItem {

    fileprivate let prepareForReuseSubject = PublishSubject<Void>()
    var preparedForReuse: Observable<Void> {
        return prepareForReuseSubject
    }

    var doubleClicked: Observable<Void> {
        return castView.doubleClicked
    }

    override var isSelected: Bool {
        didSet {
            castView.setSelection(isSelected)
        }
    }

    private var castView: SprintCollectionViewItemView {
        guard let view = view as? SprintCollectionViewItemView else {
            fatalError("Provided wrong view subclass for \(String(describing: SprintCollectionViewItem.self))")
        }
        return view
    }

    override func loadView() {
        view = SprintCollectionViewItemView()
    }

    override func prepareForReuse() {
        prepareForReuseSubject.onNext(())
        castView.clearContents()
        isSelected = false
    }

    static var identifier: String {
        return String(describing: self)
    }

    var assigneeImageSink: AnyObserver<NSImage> {
        return castView.assigneeImageSink
    }

    var priorityImageSink: AnyObserver<NSImage> {
        return castView.priorityImageSink
    }

    var typeURLSink: AnyObserver<URL> {
        return castView.typeURLSink
    }

    func update(with data: SprintElementData) {
        castView.update(with: data)
    }
}


