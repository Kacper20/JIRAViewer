//
//  BasicAuthenticationStorage.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import Locksmith

struct BasicAuthenticationStorage: Codable {
    let username: String
    let password: String
    let team: JIRATeam
}

extension BasicAuthenticationStorage: ReadableSecureStorable, GenericPasswordSecureStorable,
    CreateableSecureStorable, DeleteableSecureStorable {

    struct Keys {
        static let username = "username"
        static let password = "password"
        static let team = "team"
    }
    var service: String {
        return "JiraHelper"
    }
    var account: String {
        return "BasicAuthKeys"
    }
    var data: [String : Any] {
        return [
            Keys.username: username,
            Keys.password: password,
            Keys.team: team.name
        ]
    }

    init() {
        username = ""
        password = ""
        team = JIRATeam(name: "")
    }
}
