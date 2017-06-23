//
//  SprintViewModel.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class SprintViewModel: NSObject, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {

    private let sprintIssuesService: SprintIssuesService
    private let boardConfiguration: BoardConfiguration

    private var container: SprintIssuesContainer

    init(sprintIssuesService: SprintIssuesService, boardConfiguration: BoardConfiguration) {
        self.sprintIssuesService = sprintIssuesService
        self.boardConfiguration = boardConfiguration
        container = SprintIssuesContainer(columns: boardConfiguration.columns)
        super.init()
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
        return item
    }

//    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
//        guard let model = container.viewModel(at: indexPath) else { return .zero }
//        item?.update(with: model)
//        return item?.view.frame.size ?? .zero
//    }
}
