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
    case basicAuth(AuthenticationStorage)
}

final class AuthenticationProvider {

    func readAuthentication() -> AuthenticationStorageType? {
        if let basicAuth = readBasicAuthentication() {
            return .basicAuth(basicAuth)
        }
        return nil
    }

    func writeBasicAuthentication(
        data: LoginData,
        team: JIRATeam,
        cookieSession: CookieSession? = nil
        ) -> AuthenticationStorage {
        let storage = AuthenticationStorage(
            username: data.username,
            password: data.password,
            team: team,
            cookieSession: cookieSession
        )
        try? storage.createInSecureStore()
        return storage
    }

    private func readBasicAuthentication() -> AuthenticationStorage? {
        if let authData = AuthenticationStorage().readFromSecureStore()?.data,
            let data = AuthenticationStorage(dictData: authData) {
            return data
        }
        return nil
    }
}
