//
//  SprintViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17.02.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//
import Foundation
import RxSwift

final class SprintViewController: NSViewController {

    private let keyboardUpEventsSubject = PublishSubject<NSEvent>()

    var upEventsObserver: AnyObserver<NSEvent> {
        return keyboardUpEventsSubject.asObserver()
    }

    @IBOutlet weak var columnsInfoStackView: NSStackView!
    @IBOutlet weak var collectionView: NSCollectionView!
    private let sprintViewModel: SprintViewModel
    private let disposeBag = DisposeBag()

    init(sprintViewModel: SprintViewModel) {
        self.sprintViewModel = sprintViewModel
        super.init(nibName: String(describing: SprintViewController.self), bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView(collectionView)
        setupRequest()
        setupStyles()
    }

    private func setupRequest() {
        sprintViewModel.loadInitial()
            .subscribe(onNext: { [unowned self] in
                self.collectionView.reloadData()
            }, onError: { error in
                Logger.shared.error("Error occured: \(error)")
            }).disposed(by: disposeBag)
    }

    //TODO: Could be separated into another object
    private func setupKeysObserving() {
//        keyboardUpEventsSubject
//            .flatMap
    }

    private func setupStyles() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
    }

    private func setupCollectionView(_ collectionView: NSCollectionView) {
        let flowLayout = KanbanCollectionViewLayout()
        let sectionSpacing: CGFloat = 5.0
        flowLayout.interSectionSpacing = sectionSpacing
        flowLayout.interItemSpacing = 5.0
        flowLayout.delegate = sprintViewModel
        let layoutInfo = ColumnsLayoutInformation(
            offsetValue: sectionSpacing,
            names: sprintViewModel.columns.map { $0.name }
        )
        let layouter = SprintColumnViewsLayouter(
            stackView: columnsInfoStackView,
            layoutInfo: layoutInfo
        )
        layouter.layout()
        //TODO: Consider sticky headers instead? Will be easier to maintain, but less performant.

        collectionView.register(forDraggedTypes: [NSStringPboardType])
        collectionView.setDraggingSourceOperationMask(.every, forLocal: true)
        collectionView.isSelectable = true
        collectionView.allowsMultipleSelection = false
        collectionView.register(SprintCollectionViewItem.self, forItemWithIdentifier: SprintCollectionViewItem.identifier)
        collectionView.collectionViewLayout = flowLayout
        collectionView.dataSource = sprintViewModel
        collectionView.delegate = sprintViewModel
    }
}
