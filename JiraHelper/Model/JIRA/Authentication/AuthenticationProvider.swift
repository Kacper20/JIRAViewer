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
        let item = AuthenticationStorageItem(
            username: authData.loginData.username,
            password: authData.loginData.password,
            team: team,
            cookieSession: authData.session
        )
        if let currentAuth = readAuthentication() {
            var items = currentAuth.items
            if let indexToReplace = items.index(where: { $0.team == item.team }), indexToReplace != 0 {
                items.swapAt(0, indexToReplace)
            } else {
                items.insert(item, at: 0)
            }
            let storage = AuthenticationStorage(items: items)
            try? storage.updateInSecureStore()
            return storage
        } else {
            let storage = AuthenticationStorage(
                items: [item]
            )
            try? storage.createInSecureStore()
            return storage
        }
    }

    func getLastAuthenticationData() -> AuthenticationStorageItem? {
        return readAuthentication()?.items.first
    }

    func getOtherThanLastTeams() -> [JIRATeam] {
        guard let slice = readAuthentication()?.items.dropFirst().map({ $0.team }) else { return [] }
        return Array(slice)
    }

    func clearAuthentication() throws {
        try readAuthentication()?.deleteFromSecureStore()
    }

    private func readAuthentication() -> AuthenticationStorage? {
        if let authData = AuthenticationStorage().readFromSecureStore()?.data,
            let data = AuthenticationStorage(dictData: authData) {
            return data
        }
        return nil
    }
}
