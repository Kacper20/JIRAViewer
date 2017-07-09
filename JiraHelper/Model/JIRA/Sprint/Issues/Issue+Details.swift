//
//  IssueElements.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct IssueStatus: Decodable {
    let name: String
    let iconUrl: String
}

struct IssuePriority: Decodable {
    let name: String
    let iconUrl: String

    var pngIconUrl: String {
        return URL(string: iconUrl)?.changingPathExtension(to: "png").absoluteString ?? ""
    }
}

struct IssueComment: Decodable {
    let body: String
    let author: IssueInvolvedPerson
    let created: Date
}

struct IssueType: Decodable {
    let name: String
    let iconUrl: String
}
