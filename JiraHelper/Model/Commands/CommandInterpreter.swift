//
//  CommandInterpreter.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 22/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

protocol CommandTextInterpretable {
    func interpret(text: String)
}

protocol CommandProvider {
    var commands: Observable<Command> { get }
}

final class CommandInterpreter: CommandTextInterpretable, CommandProvider {

    private let commandSubject = PublishSubject<Command>()

    var commands: Observable<Command> {
        return commandSubject
    }

    func interpret(text: String) {
        commandSubject.onNext(.filter(text: text))
    }
}
