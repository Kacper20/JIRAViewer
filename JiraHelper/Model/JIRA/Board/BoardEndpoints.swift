//
//  BoardEndpointsProvider.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import Mapper

enum BoardEndpoints {
    static func boards() -> EndpointConfiguration<ArrayOfValuesWithPagingData<Board>> {
        return EndpointConfiguration(
            path: JIRARestAPI.buildUrl(with: "/board"),
            method: .get,
            encoding: JSONEncoding.default,
            headers: [:],
            parameters: [:],
            resourceType: .dictionary(generation: { dict in
                return try ArrayOfValuesWithPagingData(
                    map: Mapper(JSON: dict as NSDictionary),
                    valuesKey: JIRARestAPI.paginationValuesKey
                )
            })
        )
    }
}
