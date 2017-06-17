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
    let total: Int?
    let isLast: Bool?
    //TODO: Change it to failable init
    var isLastPage: Bool {
        if let isLast = isLast {
            return isLast
        } else if let total = total {
            return startAt + maxResults >= total
        } else {
            fatalError("One of the variables should be set")
        }
    }
}

struct ArrayOfValuesWithPagingData<T: Decodable>: Decodable {
    let values: [T]
    let pagingData: PagingData

    private enum CodingKeys: String, CodingKey {
        case values
        case issues //TODO: Ugly but don't know how to resolve it in other way
        case pagingData
    }

    init(from decoder: Decoder) throws {
        pagingData = try PagingData(from: decoder)
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        let valuesDecoded = try keyedContainer.decodeIfPresent([T].self, forKey: .values)
        if let values = valuesDecoded {
            self.values = values
        } else if let values = try keyedContainer.decodeIfPresent([T].self, forKey: .issues) {
            self.values = values
        } else {
            throw DecodingError.valueNotFound(
                [T].self,
                DecodingError.Context(codingPath: [CodingKeys.issues],
                                      debugDescription: "Values not found in paged response"
            ))
        }
    }
}
