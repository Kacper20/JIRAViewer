//
//  JIRATeam.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 27.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct JIRATeam: Codable {
    let name: String

    private enum CodingKeys: String, CodingKey {
        case name = ""
    }
}
