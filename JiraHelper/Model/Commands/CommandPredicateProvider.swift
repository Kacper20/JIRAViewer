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
        return { issue in
            print("Predicate run!!")
            switch command {
            case .filter(text: let text):
                guard !text.isEmpty else { return true }
                let range = issue.summary.range(of: text)
                return range != nil
            }
        }
    }
}
