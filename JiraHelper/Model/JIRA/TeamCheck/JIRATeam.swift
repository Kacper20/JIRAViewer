//
//  JIRATeam.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 27.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct JIRATeam: Codable, Equatable {
    let name: String

    static func == (lhs: JIRATeam, rhs: JIRATeam) -> Bool {
        return lhs.name == rhs.name
    }
}
