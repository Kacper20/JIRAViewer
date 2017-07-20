//
//  BasicAuthenticationStorage.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import Locksmith

struct AuthenticationStorageItem: Codable {
    let username: String
    let password: String
    let team: JIRATeam
    let cookieSession: CookieSession?

    init(username: String, password: String, team: JIRATeam, cookieSession: CookieSession?) {
        self.username = username
        self.password = password
        self.team = team
        self.cookieSession = cookieSession
    }
}

struct AuthenticationStorage: Encodable {
    //Item most recently touched by the user is at the beginning of the list
    let items: [AuthenticationStorageItem]
}

extension AuthenticationStorage: ReadableSecureStorable, GenericPasswordSecureStorable,
    CreateableSecureStorable, DeleteableSecureStorable {

    struct Keys {
        static let items = "item"
    }

    var service: String {
        return "JiraHelper"
    }

    var account: String {
        return "BasicAuthKeys"
    }

    var data: [String : Any] {
        guard let itemsDicts = try? items.flatMap({ try $0.getDict() }) else { return [:] }
        return [
            Keys.items: itemsDicts,
        ]
    }

    init?(dictData: [String : Any]) {
        guard let itemsDicts = dictData[Keys.items] as? [[String : Any]],
              let items = try? itemsDicts.flatMap(AuthenticationStorageItem.init(dict: )) else { return nil }
        guard !items.isEmpty else { return nil }
        self.items = items
    }

    init() {
        items = []
    }
}
