//
//  KanbanCollectionView.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 06.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import AppKit

final class KanbanCollectionViewLayout: NSCollectionViewLayout {
    private let cellHeight: CGFloat = 150
    private let cellWidth: CGFloat = 100

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
        for section in 0..<sectionsCount {
            let itemsCount = collectionView.numberOfItems(inSection: section)
            for item in 0..<itemsCount {
                let indexPath = IndexPath(item: item, section: section)

                let xPosition = CGFloat(section) * (cellWidth + interSectionSpacing)
                let yPosition = CGFloat(item) * (cellHeight + interItemSpacing)

                let attributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
                attributes.frame = NSRect(x: xPosition, y: yPosition, width: cellWidth, height: cellHeight)
                attributes.zIndex = 1
                layoutAttributes[indexPath] = attributes
            }
        }
        let ySizes = (0..<collectionView.numberOfSections).map {
            return CGFloat(collectionView.numberOfItems(inSection: $0)) * (cellHeight + interItemSpacing)
        }
        let contentHeight = CGFloat(ySizes.max() ?? 0)
        let contentWidth = CGFloat(collectionView.numberOfSections) * (cellWidth + interSectionSpacing)
        contentSize = NSSize(width: contentWidth, height: contentHeight)
    }

    override func shouldInvalidateLayout(
        forPreferredLayoutAttributes preferredAttributes: NSCollectionViewLayoutAttributes,
        withOriginalAttributes originalAttributes: NSCollectionViewLayoutAttributes) -> Bool {
        print("Preferred: \(preferredAttributes)")
        print("Original: \(originalAttributes)")
        return false
    }

    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        return layoutAttributes.values.filter { return rect.intersects($0.frame) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath]
    }
}
