//
//  TeamCheckEndpoints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 09.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum TeamCheckEndpoints {

    static func team() -> EndpointConfiguration<Nothing> {
        return EndpointConfiguration(
            path: "",
            method: .get,
            encoding: URLEncoding.default,
            headers: [:],
            parameters: .empty,
            resourceType: .none(Nothing())
        )
    }
}
