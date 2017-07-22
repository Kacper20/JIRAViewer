//
//  CommandPredicateProvider.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 22/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

typealias IssuePredicate = (BasicIssue) -> Bool

final class CommandPredicateProvider {
    func computePredicate(on command: Command) -> IssuePredicate {
        return { _ in
            true
        }
    }
}
