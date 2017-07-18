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

    var loginData: LoginData {
        switch self {
        case .basic(let loginData):
            return loginData
        case .cookie(let cookieWithData):
            return cookieWithData.loginData
        }
    }

    var session: CookieSession? {
        switch self {
        case .basic(_):
            return nil
        case .cookie(let cookieWithData):
            return cookieWithData.session
        }
    }
}

final class AuthenticationProvider {

    func writeAuthentication(
        _ authData: AuthenticationDataType,
        team: JIRATeam
        ) -> AuthenticationStorage {
        let storage = AuthenticationStorage(
            username: authData.loginData.username,
            password: authData.loginData.password,
            team: team,
            cookieSession: authData.session
        )
        try? storage.createInSecureStore()
        return storage
    }

    func readAuthentication() -> AuthenticationStorage? {
        if let authData = AuthenticationStorage().readFromSecureStore()?.data,
            let data = AuthenticationStorage(dictData: authData) {
            return data
        }
        return nil
    }
}
