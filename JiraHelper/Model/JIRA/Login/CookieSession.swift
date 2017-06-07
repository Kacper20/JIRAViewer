//
//  Session.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 02.06.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct CookieSessionWithLoginData {
    let session: CookieSession
    let loginData: LoginData
}

struct CookieSession {
    let name: String
    let value: String
}

extension CookieSession: Mappable {
    struct Keys {
        static let name = "name"
        static let value = "value"
    }
    
    init(map: Mapper) throws {
        try name = map.from(Keys.name)
        try value = map.from(Keys.value)
    }
}
