//
//  SprintViewModel.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

//TODO: Divide data source & delegate
final class SprintViewModel: NSObject, NSCollectionViewDataSource, KanbanCollectionViewLayoutDelegate, NSCollectionViewDelegate {

    private let sprintIssuesService: SprintIssuesService
    private let boardConfiguration: BoardConfiguration
    private let imageDownloader: ImageDownloader

    private let sampleItem = SprintCollectionViewItem(nibName: nil, bundle: nil)!

    private var container: SprintIssuesContainer

    init(
        sprintIssuesService: SprintIssuesService,
        imageDownloader: ImageDownloader,
        boardConfiguration: BoardConfiguration
        ) {
        self.imageDownloader = imageDownloader
        self.sprintIssuesService = sprintIssuesService
        self.boardConfiguration = boardConfiguration
        container = SprintIssuesContainer(columns: boardConfiguration.columns)
        super.init()
        _ = sampleItem.view
    }

    func loadInitial() -> Observable<Void> {
        return sprintIssuesService.getAll()
            .map { [weak self] issues in
                self?.container.update(with: issues)
                return ()
            }
    }

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return container.numbersOfSections()
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return container.numbersOfItems(inSection: section)
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        itemForRepresentedObjectAt indexPath: IndexPath
        ) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: SprintCollectionViewItem.identifier, for: indexPath)
        guard let sprintItem = item as? SprintCollectionViewItem, let model = container.viewModel(at: indexPath) else {
            return item
        }
        sprintItem.update(with: model)
        if let url = model.avatarUrl {
            _ = imageDownloader.getImage(from: url)
                .takeUntil(sprintItem.preparedForReuse)
                .bind(to: sprintItem.imageSink)
        }
        return item
    }

    func collectionView(_ collectionView: NSCollectionView, sizeForItemAt indexPath: IndexPath) -> NSSize {
        guard let model = container.viewModel(at: indexPath) else { return .zero }
        sampleItem.update(with: model)
        sampleItem.view.needsLayout = true
        sampleItem.view.layoutSubtreeIfNeeded()
        return sampleItem.view.frame.size
    }

    var draggedItemsPaths = Set<IndexPath>()

    func collectionView(
        _ collectionView: NSCollectionView,
        canDragItemsAt indexPaths: Set<IndexPath>,
        with event: NSEvent
        ) -> Bool {
        return true
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        writeItemsAt indexPaths: Set<IndexPath>,
        to pasteboard: NSPasteboard) -> Bool {
        return true
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        draggingSession session: NSDraggingSession,
        willBeginAt screenPoint: NSPoint,
        forItemsAt indexPaths: Set<IndexPath>
        ) {
        draggedItemsPaths = indexPaths
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        validateDrop draggingInfo: NSDraggingInfo,
        proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>,
        dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionViewDropOperation>) -> NSDragOperation {
        if proposedDropOperation.pointee == .on {
            proposedDropOperation.pointee = .before
        }
        return .move
    }



}
