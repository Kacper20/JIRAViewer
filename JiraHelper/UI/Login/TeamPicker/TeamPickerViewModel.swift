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
}

final class TeamPickerViewModel {

    private let disposeBag = DisposeBag()

    let teamName = Variable<String>("")
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
        return teamName
            .asObservable()
            .map(nonEmptyValidator.validate)
            .map { $0.isValid }
    }

    func proceedWithRequest() -> Observable<TeamPickerViewState> {
        return Observable.create { [weak self] observer in
            guard let `self` = self else { return Disposables.create() }
            observer.onNext(.loading)

            let disposable = self.teamCheckService.checkTeamAvailability(for: self.teamName.value)
                .subscribe(onNext: { value in
                    observer.onNext(.normal)
                    observer.onCompleted()
                    }, onError: { error in
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
