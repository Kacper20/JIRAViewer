//
//  TeamPickerViewModel.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 09.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class TeamPickerViewModel {

    let teamName = Variable<String>("")

    private let nonEmptyValidator = CommonValidators.nonEmptyString(message: "")

    var isValid: Observable<Bool> {
        return teamName
            .asObservable()
            .map(nonEmptyValidator.validate)
            .map { $0.isValid }
    }
}
