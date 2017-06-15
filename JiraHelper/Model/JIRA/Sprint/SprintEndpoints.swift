//
//  SprintEndpoints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 15/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum SprintEndpoints {

    static func all(forBoard board: Board) -> EndpointConfiguration<ArrayOfValuesWithPagingData<Sprint>> {
        return EndpointConfiguration(
            path: "/board/\(board.id)/sprint",
            method: .get,
            encoding: URLEncoding.default,
            headers: [:],
            parameters: [:],
            resourceType: .json
        )
    }
}
