//
//  SprintViewModel.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

struct IssueExpandRequest {
    let source: NSView
    let rect: NSRect
    let operation: Observable<DetailedIssue>
}

//TODO: Divide data source & delegate, consider renaming
final class SprintViewModel: NSObject, NSCollectionViewDataSource, KanbanCollectionViewLayoutDelegate, NSCollectionViewDelegate {

    private let sprintIssuesService: SprintIssuesService
    private let boardConfiguration: BoardConfiguration
    private let imageDownloader: ImageDownloader
    private let eventsReceiver: GlobalUIEventsReceiver
    private let assignDisposeBox = SerialDisposeBox()
    private let issueExpandSubject = PublishSubject<IssueExpandRequest>()
    private let transitionDisposeBox = SerialDisposeBox()

    private let user: User

    var assignCalledSink: AnyObserver<Void> {
        return AnyObserver.next { [weak self] in
            self?.processSelfAssigningOfSelectedIssues()
        }
    }

    var issueDetailsExpand: Observable<IssueExpandRequest> {
        return issueExpandSubject
    }

    private let sampleItem = SprintCollectionViewItem(nibName: nil, bundle: nil)!

    private var container: SprintIssuesContainer

    var columns: [KanbanColumn] {
        return boardConfiguration.columns
    }

    var managedCollectionView: NSCollectionView?

    init(
        sprintIssuesService: SprintIssuesService,
        imageDownloader: ImageDownloader,
        boardConfiguration: BoardConfiguration,
        eventsReceiver: GlobalUIEventsReceiver,
        user: User
        ) {
        self.imageDownloader = imageDownloader
        self.sprintIssuesService = sprintIssuesService
        self.boardConfiguration = boardConfiguration
        self.eventsReceiver = eventsReceiver
        self.user = user
        container = SprintIssuesContainer(columns: boardConfiguration.columns)
        super.init()
        _ = sampleItem.view
    }

    private func processSelfAssigningOfSelectedIssues() {
        collectionNonOptional { collectionView in
            let selectedPaths = collectionView.selectionIndexPaths
            let issues = selectedPaths.flatMap { self.container.issue(at: $0) }
            let serviceRequests = issues
                .map { sprintIssuesService.issueEditionService(for: $0) }
                .map { $0.assign(to: user) }
            guard let first = serviceRequests.first else { return }
            assignDisposeBox.disposable = first.subscribe(onNext: { [unowned self] updatedIssue in
                self.updateIssue(with: updatedIssue)
            })
        }
    }

    private func collectionNonOptional(_ closure: (NSCollectionView) -> Void) {
        //TODO: Is it needed?
        if let managedCollectionView = managedCollectionView {
            closure(managedCollectionView)
        }
    }

    private func updateIssue(with issue: BasicIssue) {
        if let path = container.updateIssueAndGetPath(newIssue: issue), let collection = managedCollectionView {
            collection.reloadItems(at: [path])
        }
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

        _ = sprintItem.doubleClicked
            .filterMap { _ in self.container.issue(at: indexPath) }
            .map(sprintIssuesService.getDetailedIssue(for: ))
            .flatMap { operation -> Observable<IssueExpandRequest> in
                guard let collectionSuperview = collectionView.superview else {
                    return .empty()
                }
                let sourceFrame = collectionView.convert(item.view.frame, to: collectionSuperview)
                return .just(IssueExpandRequest(source: collectionSuperview, rect: sourceFrame, operation: operation))
            }
            .takeUntil(sprintItem.preparedForReuse)
            .subscribe(onNext: { [weak self] request in
                self?.issueExpandSubject.onNext(request)
            })

        if let url = model.assigneeAvatarUrl {
            getImage(from: url, bindedTo: sprintItem, sink: sprintItem.assigneeImageSink)
        }
        getImage(from: model.priorityAvatarUrl, bindedTo: sprintItem, sink: sprintItem.priorityImageSink)
        getImage(from: model.typeAvatarUrl, bindedTo: sprintItem, sink: sprintItem.typeImageSink)
        return item
    }

    private func getImage(from url: String, bindedTo item: SprintCollectionViewItem, sink: AnyObserver<NSImage>) {
        _ = imageDownloader.getImage(from: url)
            .takeUntil(item.preparedForReuse)
            .bind(to: sink)
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
        pasteboardWriterForItemAt indexPath: IndexPath
        ) -> NSPasteboardWriting? {
        return ("" as NSString)
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

    func collectionView(
        _ collectionView: NSCollectionView,
        acceptDrop draggingInfo: NSDraggingInfo,
        indexPath: IndexPath,
        dropOperation: NSCollectionViewDropOperation
        ) -> Bool {
        guard !draggedItemsPaths.isEmpty else { return false }
        //TODO: Support multiple ??
        guard
            let first = draggedItemsPaths.first,
            let issue = container.issue(at: first),
            draggedItemsPaths.count == 1 else { return false }
        if indexPath.section != first.section {
            performTransitionRequest(for: issue, to: indexPath)
        }
        container.moveIssues(from: draggedItemsPaths, to: indexPath)
        collectionView.moveItem(at: first, to: indexPath)
        return true
    }

    enum TransitionError: Error {
        case destinationColumnDoNotExist
    }

    private func performTransitionRequest(for issue: BasicIssue, to path: IndexPath) {
        let transitionsService = sprintIssuesService.transitionsService
        let column = boardConfiguration.columns[path.section]
        self.eventsReceiver.loadingRequests.value = true
        transitionDisposeBox.disposable = transitionsService.getTransitions(for: issue)
            .flatMap { availableTransitions -> Observable<Void> in
                if let transition = availableTransitions.find({ $0.name == column.name }) {
                    return transitionsService.performTransition(transition, on: issue)
                } else {
                    return Observable.error(TransitionError.destinationColumnDoNotExist)
                }
            }.subscribe(onNext: { [unowned self] in
                self.eventsReceiver.loadingRequests.value = false
            }, onError: { [unowned self] error in
                //TODO: Should do somethiiiing, baaack
                fatalError("Error!!! \(error)")
            })
    }

    func collectionView(
        _ collectionView: NSCollectionView,
        draggingSession session: NSDraggingSession,
        endedAt screenPoint: NSPoint,
        dragOperation operation: NSDragOperation
        ) {
        draggedItemsPaths = []
    }
}
