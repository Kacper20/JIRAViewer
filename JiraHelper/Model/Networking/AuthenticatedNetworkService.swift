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
    private let authenticationType: AuthenticationType

    init(networkService: NetworkService, authenticationType: AuthenticationType) {
        self.networkService = networkService
        self.authenticationType = authenticationType
    }

    func requestAuthenticated<T>(
        basePath: String,
        configuration: EndpointConfiguration<T>)
        -> Observable<T> {
            fatalError()
    }


}
