//
//  MainViewEventsReceiver.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 02/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class GlobalUIEventsReceiver {

    let loadingRequests = Variable<Bool>(false)

    private let errorsSubject = PublishSubject<Error>()

    var errors: Observable<Error> {
        return errorsSubject.asObservable()
    }

    func sendError(_ error: Error) {
        errorsSubject.onNext(error)
    }

}
