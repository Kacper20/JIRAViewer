//
//  Observable+Extensions.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 10.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element: OptionalType {
    func filterNils() -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            if let element = element.map({ $0 }) {
                return .just(element)
            } else {
                return .empty()
            }
        }
    }
}

extension Observable {
    func discardType() -> Observable<Void> {
        return self.map { _ in return () }
    }
}

extension Observable {
    func filterMap<T>(_ mapper: @escaping (Element) -> T?) -> Observable<T> {
        return self.flatMap { element -> Observable<T> in
            if let element = mapper(element) {
                return .just(element)
            } else {
                return .empty()
            }
        }
    }
}
