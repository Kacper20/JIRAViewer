//
//  UserEndpoints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum UserEndpoints {
    static func current() -> EndpointConfiguration<User> {
        return EndpointConfiguration(
            path: "/api/latest/myself",
            method: .get,
            encoding: URLEncoding.default,
            headers: [:],
            parameters: .empty,
            resourceType: .json
        )
    }
}
