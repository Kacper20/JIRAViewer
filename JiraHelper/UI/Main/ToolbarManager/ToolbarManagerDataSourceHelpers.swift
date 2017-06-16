//
//  ToolbarManagerDataSourceHelpers.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

extension BoardsChoice {
    var texts: [String] {
        return ([selected] + rest).map { $0.name }
    }
}
