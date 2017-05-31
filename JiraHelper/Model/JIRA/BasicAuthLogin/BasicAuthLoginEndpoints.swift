//
//  BasicAuthLoginEndpoints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 30.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum BasicAuthLoginEndpoints {

    static func login(with data: BasicAuthLoginData) -> EndpointConfiguration<Void> {
        return EndpointConfiguration(
            path: "",
            method: .get,
            encoding: URLEncoding.default,
            headers: JIRARestAPI.basicAuthHeaders(username: data.username, password: data.password),
            parameters: [:],
            resourceType: .none(())
        )
    }
}
