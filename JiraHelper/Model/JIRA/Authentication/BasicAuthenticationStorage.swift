//
//  BasicAuthenticationStorage.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import Mapper
import Locksmith

struct BasicAuthenticationStorage {
    let username: String
    let password: String
    let team: JIRATeam
}

extension BasicAuthenticationStorage: ReadableSecureStorable, GenericPasswordSecureStorable,
    CreateableSecureStorable, DeleteableSecureStorable, Mappable {

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

    init(map: Mapper) throws {
        try username = map.from(Keys.username)
        try password = map.from(Keys.password)
        let teamName: String = try map.from(Keys.team)
        team = JIRATeam(name: teamName)
    }

    init() {
        username = ""
        password = ""
        team = JIRATeam(name: "")
    }

    init(data: [String : Any]) throws {
        let mapper = Mapper(JSON: data as NSDictionary)
        try self.init(map: mapper)
    }
}
