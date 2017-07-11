//
//  SprintEndpoints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 15/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum SprintEndpoints {
    static func allActive(forBoard board: Board) -> EndpointConfiguration<ArrayOfValuesWithPagingData<Sprint>> {
        return EndpointConfiguration(
            path: "/agile/latest/board/\(board.id)/sprint",
            method: .get,
            encoding: URLEncoding.default,
            headers: [:],
            parameters: .dict([
                "state" : "active"
            ]),
            resourceType: .json
        )
    }
}
