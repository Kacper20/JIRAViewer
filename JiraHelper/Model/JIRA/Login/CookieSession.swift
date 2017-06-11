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

struct CookieSession: Codable {
    let name: String
    let value: String
}
