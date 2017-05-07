//
//  JIRARestAPI.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct JIRARestAPI {

    static let apiPath = "/rest/agile/1.0"
    static let paginationValuesKey = "values"

    static func buildUrl(with resourcePath: String) -> String {
        return apiPath + resourcePath
    }
}
