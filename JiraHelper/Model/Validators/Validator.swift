//
//  Validator.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 10.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation


struct Validator<T> {
    enum Result {
        case valid
        case invalid(message: String)

        var isValid: Bool {
            if case .valid = self {
                return true
            }
            return false
        }
    }

    private let validation: (T) -> Result

    init(validation: @escaping (T) -> Result) {
        self.validation = validation
    }

    func validate(_ data: T) -> Result {
        return validation(data)
    }
}
