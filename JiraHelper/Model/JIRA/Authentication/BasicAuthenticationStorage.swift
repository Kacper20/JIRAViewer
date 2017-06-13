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

    //TODO: Try to implement it in other way
    init?(dictData: [String : Any]) {
        guard let team = dictData[Keys.team] as? String, let username = dictData[Keys.username] as? String,
            let password = dictData[Keys.password] as? String else { return nil }
        self.team = JIRATeam(name: team)
        self.username = username
        self.password = password
    }

    init() {
        username = ""
        password = ""
        team = JIRATeam(name: "")
    }
}
