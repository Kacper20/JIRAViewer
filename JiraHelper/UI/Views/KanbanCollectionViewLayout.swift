//
//  KanbanCollectionView.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 06.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import AppKit

protocol KanbanCollectionViewLayoutDelegate: class {
    func collectionView(_ collectionView: NSCollectionView, sizeForItemAt indexPath: IndexPath) -> NSSize
}

final class KanbanCollectionViewLayout: NSCollectionViewLayout {

    weak var delegate: KanbanCollectionViewLayoutDelegate?

    //TODO: Should not be hardcoded in two places
    var itemSize = NSSize(width: 124, height: 150)
    var interSectionSpacing: CGFloat = 0.0
    var interItemSpacing: CGFloat = 0.0

    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var layoutAttributes = [IndexPath : NSCollectionViewLayoutAttributes]()

    var contentSize: NSSize = .zero

    override var collectionViewContentSize: NSSize {
        return contentSize
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }
        let sectionsCount = collectionView.numberOfSections
        var currentXOffset: CGFloat = 0
        var maxHeight: CGFloat = 0
        for section in 0..<sectionsCount {
            var currentYOffset: CGFloat = 0
            let itemsCount = collectionView.numberOfItems(inSection: section)
            var maxItemWidth: CGFloat = itemSize.width
            for item in 0..<itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                let size: NSSize
                if let delegate = delegate {
                    size = delegate.collectionView(collectionView, sizeForItemAt: indexPath)
                } else {
                    size = itemSize
                }
                maxItemWidth = max(maxItemWidth, size.width)

                let attributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
                attributes.frame = NSRect(x: currentXOffset, y: currentYOffset, width: size.width, height: size.height)
                attributes.zIndex = 1
                layoutAttributes[indexPath] = attributes
                currentYOffset += size.height + interItemSpacing
            }
            maxHeight = max(maxHeight, currentYOffset)
            currentXOffset += maxItemWidth + interSectionSpacing
        }
        contentSize = NSSize(width: currentXOffset, height: maxHeight)
    }

    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        return layoutAttributes.values.filter { return rect.intersects($0.frame) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath]
    }
}
