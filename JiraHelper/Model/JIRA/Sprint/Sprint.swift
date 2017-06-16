//
//  Sprint.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 15/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct SprintSetupData: Decodable {
    let originBoardId: Int
    let startDate: Date
    let endDate: Date
}

struct Sprint: Decodable {

    enum State: Decodable {
        case future
        case closed(SprintSetupData, completionDate: Date)
        case active(SprintSetupData)

        private enum CodingKeys: String, CodingKey {
            case state
            case future
            case closed
            case active
            case completeDate
        }

        init(from decoder: Decoder) throws {
            let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
            let state = try keyedContainer.decode(String.self, forKey: .state)
            switch state {
            case CodingKeys.closed.rawValue:
                self = .closed(
                    try SprintSetupData(from: decoder),
                    completionDate: try keyedContainer.decode(Date.self, forKey: .completeDate)
                )
            case CodingKeys.active.rawValue:
                self = .active(try SprintSetupData(from: decoder))
            case CodingKeys.future.rawValue:
                self = .future
            default:
                throw DecodingError.valueNotFound(
                    String.self,
                    DecodingError.Context(codingPath: [CodingKeys.state],
                                          debugDescription: "Type mismatch in state field"
                ))
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case state
        case url = "self"
        case name
        case goal
    }

    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try keyedContainer.decode(Int.self, forKey: .id)
        url = try keyedContainer.decode(String.self, forKey: .url)
        name = try keyedContainer.decode(String.self, forKey: .name)
        goal = try keyedContainer.decodeIfPresent(String.self, forKey: .goal)
        state = try State(from: decoder)
    }

    let id: Int
    let state: State
    let url: String
    let name: String
    let goal: String?
}
