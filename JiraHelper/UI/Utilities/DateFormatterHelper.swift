//
//  DateFormatterHelper.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 05/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct DateFormatterHelper {
    private static let dateFormatter = DateFormatter()

    static func issueDetailsFormat(date: Date) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from:date)
    }

    static func commentFormat(date: Date) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from:date)
    }
}
