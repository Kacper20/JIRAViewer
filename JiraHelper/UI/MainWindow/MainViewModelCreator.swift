//
//  MainViewModelCreator.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 15/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class MainViewModelCreator {
    private let networkService: AuthenticatedNetworkService
    private let boardsService: BoardService
    private let sprintsService: SprintsService

    init(networkService: AuthenticatedNetworkService) {
        self.networkService = networkService
        self.boardsService = BoardService(networkService: networkService)
        self.sprintsService = SprintsService(networkService: networkService)
    }

    func create() -> Observable<MainViewModel> {
        return boardsService
            .boards()
            .flatMap { [unowned self] boardsResult in
                return self.sprintsService.allActive(for: $0.selectedBoard).map { }
            }
            .subscribe(onNext: { [unowned self] sprints in
                self.presentVC()
                }, onError: { error in
                    print(error)
            }).disposed(by: disposeBag)

    }
}
