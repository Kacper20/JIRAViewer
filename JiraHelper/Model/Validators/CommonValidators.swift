//
//  CommonValidators.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 10.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct CommonValidators {

    private init() { }
    
    static func nonEmptyString(message: String) -> Validator<String> {
        return Validator<String>(validation: {
            if $0.characters.isEmpty {
                return .invalid(message: message)
            }
            return .valid
        })
    }
}
