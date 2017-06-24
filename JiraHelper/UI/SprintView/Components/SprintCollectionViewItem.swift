//
//  SprintCollectionViewItem.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 06.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Cocoa
import AppKit

final class SprintCollectionViewItem: NSCollectionViewItem {

    private var castView: SprintCollectionViewItemView {
        guard let view = view as? SprintCollectionViewItemView else {
            fatalError("Provided wrong view subclass for \(String(describing: SprintCollectionViewItem.self))")
        }
        return view
    }

    override func loadView() {
        view = SprintCollectionViewItemView()
    }

    static var identifier: String {
        return String(describing: self)
    }

    func update(with data: SprintElementData) {
        castView.update(with: data)
    }
}

extension SprintCollectionViewItem {
}


