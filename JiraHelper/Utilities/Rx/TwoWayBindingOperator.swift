//
//  TwoWayBindingOperator.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 27.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import AppKit

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

infix operator <-> : DefaultPrecedence

func <-> <T>(property: ControlProperty<T?>, variable: Variable<T>) -> Disposable {

    let bindToUIDisposable = variable.asObservable()
        .bind(to: property)
    let bindToVariable = property
        .subscribe(onNext: { value in
            if let value = value {
                variable.value = value
            }
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToVariable)
}
