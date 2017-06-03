//
//  BasicAuthViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Cocoa
import RxSwift

class LoginViewController<T: LoginService, LoggedResource>: NSViewController where T.Result == LoggedResource {

    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var passwordField: NSTextField!

    @IBOutlet weak var loginButton: NSButton!

    private let disposeBag = DisposeBag()

    private let team: JIRATeam
    private let viewModel: LoginViewModel<T>

    private let onLoggedIn: (LoggedResource) -> Void

    init(
        team: JIRATeam,
        viewModel: LoginViewModel<T>,
        onLoggedIn: @escaping (LoggedResource) -> Void
        ) {
        self.team = team
        self.viewModel = viewModel
        self.onLoggedIn = onLoggedIn
        super.init(nibName: String(describing: LoginViewController.self), bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var viewStateSink: AnyObserver<LoginViewState<LoggedResource>> {
        return AnyObserver { [weak self] event in
            guard let `self` = self else { return }
            switch event {
            case .next(.complete(let data)):
                self.onLoggedIn(data)
            default: break
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.isValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        (usernameField.rx.text <-> viewModel.username).disposed(by: disposeBag)
        (passwordField.rx.text <-> viewModel.password).disposed(by: disposeBag)

        loginButton.rx.tap
            .flatMap { [unowned self] in self.viewModel.proceedWithRequest() }
            .bind(to: viewStateSink)
            .disposed(by: disposeBag)
    }
}
