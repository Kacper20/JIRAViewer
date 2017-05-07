//
//  SprintCollectionView.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 06.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class SprintCollectionView: NSCollectionView {

    override func setFrameSize(_ newSize: NSSize) {
        var newSize = newSize
        if let width = collectionViewLayout?.collectionViewContentSize.width, newSize.width != width  {
            newSize.width = width
        }
        super.setFrameSize(newSize)
    }
}
