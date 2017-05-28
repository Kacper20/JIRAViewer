//
//  AuthenticationProvider.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum AuthenticationType {
    case basicAuth(BasicAuthenticationStorage)
}

final class AuthenticationProvider {

    func readAuthentication() -> AuthenticationType? {
        if let basicAuth = readBasicAuthentication() {
            return .basicAuth(basicAuth)
        }
        return nil
    }

    private func readBasicAuthentication() -> BasicAuthenticationStorage? {
        if let authData = BasicAuthenticationStorage().readFromSecureStore()?.data,
            let data = try? BasicAuthenticationStorage(data: authData) {
            return data
        }
        return nil
    }
}
