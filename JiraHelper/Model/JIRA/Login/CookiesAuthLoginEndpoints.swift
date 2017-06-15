//
//  CookiesAuthLoginEndpoints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 02.06.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum CookieAuthLoginEndpoints {
    static func login(with data: LoginData) -> EndpointConfiguration<CookieSession> {
        return EndpointConfiguration(
            path: "",
            method: .get,
            encoding: URLEncoding.default,
            headers: JIRARestAPI.basicAuthHeaders(username: data.username, password: data.password),
            parameters: [:],
            resourceType: .json
        )
    }
}
