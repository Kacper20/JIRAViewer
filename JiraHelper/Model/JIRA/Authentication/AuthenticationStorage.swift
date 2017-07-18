//
//  BasicAuthenticationStorage.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import Locksmith

struct AuthenticationStorage: Encodable {
    let username: String
    let password: String
    let team: JIRATeam
    let cookieSession: CookieSession?
}

extension AuthenticationStorage: ReadableSecureStorable, GenericPasswordSecureStorable,
    CreateableSecureStorable, DeleteableSecureStorable {

    struct Keys {
        static let username = "username"
        static let password = "password"
        static let team = "team"
        static let cookieName = "cookieName"
        static let cookieValue = "cookieValue"
    }

    var service: String {
        return "JiraHelper"
    }

    var account: String {
        return "BasicAuthKeys"
    }

    var data: [String : Any] {
        var baseData = [
            Keys.username: username,
            Keys.password: password,
            Keys.team: team.name
        ]

        if let cookie = cookieSession {
            baseData[Keys.cookieName] = cookie.name
            baseData[Keys.cookieValue] = cookie.value
        }
        return baseData
    }

    //TODO: Try to implement it in other way
    init?(dictData: [String : Any]) {
        guard let team = dictData[Keys.team] as? String, let username = dictData[Keys.username] as? String,
            let password = dictData[Keys.password] as? String else { return nil }
        self.team = JIRATeam(name: team)
        self.username = username
        self.password = password

        if let cookieName = dictData[Keys.cookieName] as? String,
            let cookieValue = dictData[Keys.cookieValue] as? String {
            self.cookieSession = CookieSession(name: cookieName, value: cookieValue)
        } else {
            self.cookieSession = nil
        }
    }

    init() {
        username = ""
        password = ""
        team = JIRATeam(name: "")
        self.cookieSession = nil
    }
}
