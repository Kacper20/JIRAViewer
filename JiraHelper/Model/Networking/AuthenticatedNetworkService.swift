//
//  AuthenticatedNetworkService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class AuthenticatedNetworkService {

    private let networkService: NetworkService
    private let authentication: BasicAuthenticationStorage

    init(networkService: NetworkService, authentication: BasicAuthenticationStorage) {
        self.networkService = networkService
        self.authentication = authentication
    }

    func requestAuthenticated<T>(
        basePath: String,
        configuration: EndpointConfiguration<T>)
        -> Observable<T> {
            fatalError()
    }
}
