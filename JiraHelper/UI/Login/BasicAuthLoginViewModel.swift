//
//  BasicAuthLoginViewModel.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

enum BasicAuthLoginViewState {
    case loading
    case error(String)
    case normal
    case complete //TODO: HACK
}

final class BasicAuthLoginViewModel {

    let username = Variable<String>("")
    let password = Variable<String>("")

    private let nonEmptyValidator = CommonValidators.nonEmptyString(message: "")

    private let service: BasicAuthLoginService

    init(service: BasicAuthLoginService) {
        self.service = service
    }

    var isValid: Observable<Bool> {
        let validatorUsed = nonEmptyValidator

        return Observable.combineLatest([username, password]) { collection in
            return collection.all { validatorUsed.validate($0).isValid }
        }
    }

    func proceedWithRequest() -> Observable<BasicAuthLoginViewState> {
        return Observable.create { [weak self] observer in
            guard let `self` = self else { return Disposables.create() }
            observer.onNext(.loading)

            let disposable = self.service.login(
                with: BasicAuthLoginData(username: username.value, password: password.value)
                )
                .subscribe(onNext: { value in
                    observer.onNext(.complete)
                    observer.onCompleted()
                }, onError: { error in
                    //TODO: Handle error
                })
            return disposable
        }
    }
}
