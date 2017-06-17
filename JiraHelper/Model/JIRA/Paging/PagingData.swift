//
//  PagingData.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct PagingData: Codable {
    let startAt: Int
    let maxResults: Int
    let total: Int

    var isLast: Bool {
        return startAt + maxResults >= total
    }
}

struct ArrayOfValuesWithPagingData<T: Decodable>: Decodable {
    let values: [T]
    let pagingData: PagingData

    private enum CodingKeys: String, CodingKey {
        case values
        case pagingData
    }

    init(from decoder: Decoder) throws {
        pagingData = try PagingData(from: decoder)
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        values = try keyedContainer.decode([T].self, forKey: .values)
    }
}
