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

    func request<T>(
        configuration: EndpointConfiguration<T>)
        -> Observable<T> {
        let hostUrl = JIRARestAPI.host(for: authentication.team.name)
        let basePath = hostUrl + JIRARestAPI.apiPath
        var configuration = configuration
        configuration.headers = JIRARestAPI.basicAuthHeaders(
            username: authentication.username,
            password: authentication.password
        )
        return networkService.request(basePath: basePath, configuration: configuration)
    }
}
