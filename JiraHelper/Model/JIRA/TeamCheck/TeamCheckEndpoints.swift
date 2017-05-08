//
//  TeamCheckEndpoints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 09.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct TeamCheckEndpoints {

    private let teamName: String

    init(teamName: String) {
        self.teamName = teamName
    }

    func boards() -> EndpointConfiguration<ArrayOfValuesWithPagingData<Board>> {
        return EndpointConfiguration(
            path: JIRARestAPI.buildUrl(with: "/board"),
            method: .get,
            encoding: JSONEncoding.default,
            headers: nil,
            parameters: [:],
            resource: { dict in
                return try ArrayOfValuesWithPagingData(
                    map: Mapper(JSON: dict as NSDictionary),
                    valuesKey: JIRARestAPI.paginationValuesKey
                )
        }
        )
    }
}
