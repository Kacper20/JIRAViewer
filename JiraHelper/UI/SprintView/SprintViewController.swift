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

    @IBOutlet weak var collectionView: NSCollectionView!
    private let sprintViewModel: SprintViewModel
    private let disposeBag = DisposeBag()

    init(sprintViewModel: SprintViewModel) {
        self.sprintViewModel = sprintViewModel
        super.init(nibName: "SprintViewController", bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView(collectionView)
        setupRequest()
    }

    private func setupRequest() {
        sprintViewModel.loadInitial()
            .subscribe(onNext: { [unowned self] in
                self.collectionView.reloadData()
            }, onError: { error in
                Logger.shared.error("Error occured: \(error)")
            }).disposed(by: disposeBag)
    }

    private func setupCollectionView(_ collectionView: NSCollectionView) {
        let flowLayout = KanbanCollectionViewLayout()
        flowLayout.interSectionSpacing = 5.0
        flowLayout.interItemSpacing = 5.0


        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
        collectionView.dataSource = sprintViewModel
    }
}
