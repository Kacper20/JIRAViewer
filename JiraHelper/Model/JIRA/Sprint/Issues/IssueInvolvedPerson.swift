//
//  IssueAssignee.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 24/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct IssueInvolvedPerson: Decodable {
    
    let avatarUrl: String
    let name: String

    private enum CodingKeys: String, CodingKey {
        case avatarUrls
        case name = "displayName"

    }
    private enum AvatarsCodingKeys: String, CodingKey {
        case midSize = "48x48"
    }

    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        let avatarsContainer = try keyedContainer.nestedContainer(keyedBy: AvatarsCodingKeys.self, forKey: .avatarUrls)
        avatarUrl = try avatarsContainer.decode(String.self, forKey: .midSize)
        name = try keyedContainer.decode(String.self, forKey: .name)
    }
}
