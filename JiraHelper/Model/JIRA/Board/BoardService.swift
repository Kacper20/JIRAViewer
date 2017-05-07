//
//  BoardsService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class BoardService {
    private let networkService: NetworkService
    private let authenticationProvider: AuthenticationProvider
    private let endpoints: BoardEndpoints

    init(networkService: NetworkService, authenticationProvider: AuthenticationProvider) {
        self.networkService = networkService
        self.authenticationProvider = authenticationProvider
        self.endpoints = BoardEndpoints(authenticationProvider: authenticationProvider)
    }

    func allBoards() -> Observable<[Board]> {
        //TODO: Hardcoded URL
        return networkService.request(
            basePath: "",
            configuration: endpoints.boards()
        )
        .map { $0.values }
    }
}
