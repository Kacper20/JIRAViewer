//
//  TeamCheckEndpoints.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 09.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct TeamCheckEndpoints {

    private let teamName: String

    init(teamName: String) {
        self.teamName = teamName
    }

    func team() -> EndpointConfiguration<Void> {
        return EndpointConfiguration(
            path: "https://\(teamName).atlassian.net/",
            method: .get,
            encoding: JSONEncoding.default,
            headers: [:],
            parameters: [:],
            resourceType: .fromData(generation: { _ in return })
        )
    }
}
