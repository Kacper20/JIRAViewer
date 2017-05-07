//
//  SprintViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17.02.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class SprintViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!

    init() {
        super.init(nibName: "SprintViewController", bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView(collectionView)
    }

    private func setupCollectionView(_ collectionView: NSCollectionView) {
        let flowLayout = KanbanCollectionViewLayout()
        flowLayout.interSectionSpacing = 5.0
        flowLayout.interItemSpacing = 5.0


        collectionView.collectionViewLayout = flowLayout
        // 2
        view.wantsLayer = true
        // 3
        collectionView.dataSource = self
    }
}

extension SprintViewController: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 30
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: SprintCollectionViewItem.identifier, for: indexPath)
        return item
    }

}


