//
//  SerialDisposeBox.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 02/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

import Foundation
import RxSwift

final class SerialDisposeBox {

    private let serialDisposable = SerialDisposable()

    var disposable: Disposable {
        get {
            return serialDisposable.disposable
        }
        set {
            serialDisposable.disposable = newValue
        }
    }

    func dispose() {
        serialDisposable.dispose()
    }

    deinit {
        serialDisposable.dispose()
    }
}
