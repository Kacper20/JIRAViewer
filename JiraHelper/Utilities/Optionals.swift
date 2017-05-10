//
//  Optionals.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 06.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

infix operator !!
    // swiftlint:disable force_unwrapping
func !! <T>(wrapped: T?, failureText: @autoclosure () -> String) -> T {
    // swiftlint:enable force_unwrapping
    if let x = wrapped {
        return x
    }
    fatalError(failureText())
}

/*
 Protocol that allows for writing certain types of extensions on types operating on optionals that
 wouldn't be available in other way
 */
protocol OptionalType {
    associatedtype Wrapped
    func map<U>(_ f: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: OptionalType {}
