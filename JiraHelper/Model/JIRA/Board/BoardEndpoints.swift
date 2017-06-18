//
//  BoardEndpointsProvider.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum BoardEndpoints {
    static func boards() -> EndpointConfiguration<ArrayOfValuesWithPagingData<Board>> {
        return EndpointConfiguration(
            path: "/board",
            method: .get,
            encoding: URLEncoding.default,
            headers: [:],
            parameters: [:],
            resourceType: .json
        )
    }

    static func configuration(for board: Board) -> EndpointConfiguration<BoardConfiguration> {
        return EndpointConfiguration(
            path: "/board/\(board.id)/configuration",
            method: .get,
            encoding: JSONEncoding.default,
            headers: [:],
            parameters: [:],
            resourceType: .json
        )
    }
}
