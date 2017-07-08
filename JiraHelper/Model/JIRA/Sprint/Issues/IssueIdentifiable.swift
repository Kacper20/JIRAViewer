//
//  IssueIdentifiable.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 08/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

protocol IssueIdentifiable {
    var id: String { get }
}

extension BasicIssue: IssueIdentifiable { }
extension DetailedIssue: IssueIdentifiable { }
