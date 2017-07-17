//
//  CookiesAuthLoginEndpoints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 02.06.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum CookieAuthLoginEndpoints {
    struct CookieSessionResult: Decodable {
        let session: CookieSession
    }

    static func login(with data: LoginData) -> EndpointConfiguration<CookieSessionResult> {
        return EndpointConfiguration(
            path: "/jira/rest/auth/latest/session",
            method: .get,
            encoding: URLEncoding.default,
            headers: [:],
            parameters: .dict([
                "username" : data.username,
                "password" : data.password
                ]),
            resourceType: .json
        )
    }
}
