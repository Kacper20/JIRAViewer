//
//  UserService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class UserService {
    private let networkService: AuthenticatedNetworkService

    init(networkService: AuthenticatedNetworkService) {
        self.networkService = networkService
    }

    func getMyself() -> Observable<User> {
        return networkService.request(configuration: UserEndpoints.current())
    }
}
