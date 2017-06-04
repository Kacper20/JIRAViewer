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
        let size = collectionViewLayout?.collectionViewContentSize ?? newSize
        super.setFrameSize(size)
        if let scrollView = enclosingScrollView {
            scrollView.hasHorizontalScroller = size.width > scrollView.frame.width
        }
    }
}
