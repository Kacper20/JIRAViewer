//
//  TeamPickerViewModel.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 09.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

enum TeamPickerViewState {
    case loading
    case error(String)
    case normal
    case complete //TODO: HACK
}

final class TeamPickerViewModel {
    let teamName = Variable<String>("")
    private let disposeBag = DisposeBag()

    private let nonEmptyValidator = CommonValidators.nonEmptyString(message: "")
    private let teamCheckService: TeamCheckService

    //TODO: Inject these four
    private let appLifecycleMonitoring = AppLifecycleMonitor()
    private let pasteboardService = PasteboardService()
    private let teamURLExtractor = TeamURLExtractor()

    init(teamCheckService: TeamCheckService) {
        self.teamCheckService = teamCheckService
        setupPasteboardFlow()
    }

    var pickedTeam: JIRATeam {
        return JIRATeam(name: teamName.value)
    }

    var isValid: Observable<Bool> {
        let validatorUsed = nonEmptyValidator
        return teamName
            .asObservable()
            .map(validatorUsed.validate)
            .map { $0.isValid }
    }

    func proceedWithRequest() -> Observable<TeamPickerViewState> {
        return Observable.create { [weak self] observer in
            guard let `self` = self else { return Disposables.create() }
            observer.onNext(.loading)

            let disposable = self.teamCheckService.checkTeamAvailability(for: self.teamName.value)
                .subscribe(onNext: { value in
                    observer.onNext(.complete)
                    observer.onCompleted()
                    }, onError: { error in
                        //TODO: Handling errors
                })
            return disposable
        }
    }

    private func setupPasteboardFlow() {
        let teamPasteboardFills = appLifecycleMonitoring.didBecomeActive
            .map { [unowned self] _ -> String? in
                if let value = self.pasteboardService.readLastString(),
                    let team = self.teamURLExtractor.extractTeamName(from: value) {
                    return team
                }
                return nil
            }
            .filterNils()

        teamPasteboardFills
            .bind(to: teamName)
            .disposed(by: disposeBag)
    }
}
