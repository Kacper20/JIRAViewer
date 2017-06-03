//
//  Environment.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 03.06.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum AuthenticationChosen {
    case cookies
    case basicAuth
}

struct Environment {

    var authentication: AuthenticationChosen {
        return .basicAuth
    }
}
