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
    }

    static var identifier: String {
        return String(describing: self)
    }

    var imageSink: AnyObserver<NSImage> {
        return castView.imageSink
    }

    func update(with data: SprintElementData) {
        castView.update(with: data)
    }
}


