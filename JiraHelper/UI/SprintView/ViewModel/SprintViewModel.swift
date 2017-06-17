//
//  SprintViewModel.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class SprintViewModel: NSObject, NSCollectionViewDataSource {

    private let sprintIssuesService: SprintIssuesService
    private var container = SprintIssuesContainer()

    init(sprintIssuesService: SprintIssuesService) {
        self.sprintIssuesService = sprintIssuesService
    }

    func loadInitial() -> Observable<Void> {
        return sprintIssuesService.getAll()
            .map { [weak self] issues in
                self?.container.update(with: issues)
                return ()
            }
    }

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 30
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: SprintCollectionViewItem.identifier, for: indexPath)
        guard let sprintItem = item as? SprintCollectionViewItem else { return item }

        sprintItem.itemNameField.stringValue = "S\(indexPath.section), I: \(indexPath.item)"
        return item
    }
}
