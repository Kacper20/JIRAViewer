//
//  LoginViewModel.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

enum LoginViewState<CompletionResult> {
    case loading
    case error(String)
    case normal
    case complete(data: CompletionResult)
}

protocol LoginViewModelType {
    var username: Variable<String> { get }
    var password: Variable<String> { get }

    var isValid: Observable<Bool> { get }

    associatedtype LoginResult

    func proceedWithRequest() -> Observable<LoginViewState<LoginResult>>
}

final class LoginViewModel<T: LoginService>: LoginViewModelType {

    let username = Variable<String>("")
    let password = Variable<String>("")

    private let nonEmptyValidator = CommonValidators.nonEmptyString(message: "")

    private let service: T

    init(service: T) {
        self.service = service
    }

    var isValid: Observable<Bool> {
        let validatorUsed = nonEmptyValidator

        return Observable.combineLatest([username.asObservable(), password.asObservable()]) { collection in
            return collection.all { return validatorUsed.validate($0).isValid }
        }
    }

    func proceedWithRequest() -> Observable<LoginViewState<T.Result>> {
        return Observable.create { [weak self] observer in
            guard let `self` = self else { return Disposables.create() }
            observer.onNext(.loading)

            let loginData = LoginData(
                username: self.username.value,
                password: self.password.value
            )
            let disposable = self.service.login(
                with: loginData)
                .subscribe(onNext: { value in
                    observer.onNext(.complete(data: value))
                    observer.onCompleted()
                }, onError: { error in
                    //TODO: Handle error
                })
            return disposable
        }
    }
}
