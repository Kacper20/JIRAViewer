//
//  JIRARestAPI.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct JIRARestAPI {

    static let apiPath = "/rest"
    static let paginationValuesKey = "values"

    static func buildUrl(with resourcePath: String) -> String {
        return apiPath + resourcePath
    }

    static func host(for teamName: String) -> String {
        return "https://\(teamName).atlassian.net"
    }

    static func basicAuthHeaders(username: String, password: String) -> [String : String] {
        let passwordString = "\(username):\(password)"
        guard let data = passwordString.data(using: .utf8) else { return [:] }
        let base64Encoded = data.base64EncodedString()
        return ["Authorization" : "Basic \(base64Encoded)"]
    }

    enum RequestType {
        case authorization
        case api
    }

    static func buildAuthPath(for resourcePath: String) -> String {
        return "/rest" + resourcePath
    }
}
