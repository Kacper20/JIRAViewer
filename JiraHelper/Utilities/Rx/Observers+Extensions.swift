//
//  Observers+Extensions.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 24/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

extension AnyObserver {
    static func next(_ nextClosure: @escaping (E) -> Void) -> AnyObserver<E> {
        return self.init(eventHandler: { (event: Event<E>) -> Void in
            switch event {
            case .next(let element):
                nextClosure(element)
                break
            case .completed:
                break
            case .error:
                break
            }
        })
    }

    static func empty() -> AnyObserver<E> {
        return self.init(eventHandler: { (event: Event<E>) -> Void in
            switch event {
            case .next: break
            case .error: break
            case .completed: break
            }
        })
    }
}
