//
//  IssueAssignee.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 24/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct IssueAssignee: Decodable {
    let avatarUrl: String

    private enum CodingKeys: String, CodingKey {
        case avatarUrls

    }
    private enum AvatarsCodingKeys: String, CodingKey {
        case midSize = "32x32"
    }

    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        let avatarsContainer = try keyedContainer.nestedContainer(keyedBy: AvatarsCodingKeys.self, forKey: .avatarUrls)
        avatarUrl = try avatarsContainer.decode(String.self, forKey: .midSize)
    }
}
