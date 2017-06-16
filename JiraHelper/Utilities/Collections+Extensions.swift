//
//  Collections+Extensions.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 30.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

extension Sequence {
    func find(_ predicate: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for elem in self where predicate(elem) {
            return elem
        }
        return nil
    }

    func any(_ predicate: (Iterator.Element) -> Bool) -> Bool {
        return find(predicate) != nil
    }

    func all(_ predicate: (Iterator.Element) -> Bool) -> Bool {
        for elem in self where !predicate(elem) {
            return false
        }
        return true
    }
}

extension Array {
    func decomposed() -> (head: Element, tail: [Element])? {
        guard let first = first else { return nil }
        return (first, Array(dropFirst()))
    }
}

extension Sequence {
    func take(while predicate: (Iterator.Element) -> Bool) -> [Iterator.Element] {
        var array = Array<Iterator.Element>()
        for elem in self {
            if predicate(elem) {
                array.append(elem)
            } else {
                return array
            }
        }
        return array
    }
}

extension Dictionary {
    mutating func merge<S: Sequence>(_ other: S) where S.Iterator.Element == (key: Key, value: Value) {
        for (k, v) in other {
            self[k] = v
        }
    }

    func mapValues<T>(fun: (Value) throws -> T) rethrows -> [Key: T] {
        var result = [Key: T]()
        for elem in self { result[elem.key] = try fun(elem.value) }
        return result
    }

    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: Key, value: Value) {
        self = [:]
        self.merge(sequence)
    }
}
