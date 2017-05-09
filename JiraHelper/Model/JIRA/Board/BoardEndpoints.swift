//
//  BoardEndpointsProvider.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import Mapper

struct BoardEndpoints {
    private let authHeaders: [String : String]

    init(authenticationProvider: AuthenticationProvider) {
        self.authHeaders = authenticationProvider.headers
    }

    func boards() -> EndpointConfiguration<ArrayOfValuesWithPagingData<Board>> {
        return EndpointConfiguration(
            path: JIRARestAPI.buildUrl(with: "/board"),
            method: .get,
            encoding: JSONEncoding.default,
            headers: authHeaders,
            parameters: [:],
            resourceType: .fromDictionary(generation: { dict in
                return try ArrayOfValuesWithPagingData(
                    map: Mapper(JSON: dict as NSDictionary),
                    valuesKey: JIRARestAPI.paginationValuesKey
                )
            })
        )
    }
}
