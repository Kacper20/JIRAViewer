//
//  AuthenticationProvider.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum AuthenticationDataType {
    case basic(LoginData)
    case cookie(CookieSessionWithLoginData)
}

enum AuthenticationStorageType {
    case basicAuth(BasicAuthenticationStorage)
}

final class AuthenticationProvider {

    func readAuthentication() -> AuthenticationStorageType? {
        if let basicAuth = readBasicAuthentication() {
            return .basicAuth(basicAuth)
        }
        return nil
    }

    func writeBasicAuthentication(data: LoginData, team: JIRATeam) -> BasicAuthenticationStorage {
        let storage = BasicAuthenticationStorage(username: data.username, password: data.password, team: team)
        try? storage.createInSecureStore()
        return storage
    }

    private func readBasicAuthentication() -> BasicAuthenticationStorage? {
        if let authData = BasicAuthenticationStorage().readFromSecureStore()?.data,
            let data = BasicAuthenticationStorage(dictData: authData) {
            return data
        }
        return nil
    }
}
