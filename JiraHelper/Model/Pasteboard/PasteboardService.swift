//
//  PasteboardService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 25.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class PasteboardService {

    private let pasteboard = NSPasteboard.general()

    func readLastString() -> String? {
        return pasteboard.string(forType: NSPasteboardTypeString)
    }
}
