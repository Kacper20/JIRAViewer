//
//  Logger.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import SwiftyBeaver

struct Logger {

    static let shared = Logger()

    private let usedLogger = SwiftyBeaver.self

    private init() {
        usedLogger.addDestination(ConsoleDestination())
    }

    func verbose(_ message: @autoclosure () -> Any) {
        usedLogger.verbose(message)
    }

    func debug(_ message: @autoclosure () -> Any) {
        usedLogger.debug(message)
    }

    func info(_ message: @autoclosure () -> Any) {
        usedLogger.info(message)
    }

    func warning(_ message: @autoclosure () -> Any) {
        usedLogger.warning(message)
    }

    func error(_ message: @autoclosure () -> Any) {
        usedLogger.error(message)
    }
}
