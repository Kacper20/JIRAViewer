//
//  TeamPickerViewModel.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 09.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

struct TeamPickerViewState {
    let buttonEnabled: Bool
}

final class TeamPickerViewModel {

    let teamName = Variable<String>("")
    private let nonEmptyValidator = CommonValidators.nonEmptyString(message: "")

    private let teamCheckService: TeamCheckService

    init(teamCheckService: TeamCheckService) {
        self.teamCheckService = teamCheckService
    }

    var isValid: Observable<Bool> {
        return teamName
            .asObservable()
            .map(nonEmptyValidator.validate)
            .map { $0.isValid }
    }

//    func proceedWithRequest() -> Observable<TeamPickerViewState> {
//        return Observable.create { observer in
//            return teamCheckService.checkTeamAvailability(for: teamName.value)
//                .subscribe(onNext: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
//
//        }
//    }
}
