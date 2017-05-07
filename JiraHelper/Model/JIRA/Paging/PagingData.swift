//
//  PagingData.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import Mapper

struct PagingData {
    let startAt: Int
    let maxResults: Int
    let isLast: Bool
    let total: Int?
}

struct ArrayOfValuesWithPagingData<T: Mappable> {
    let values: [T]
    let pagingData: PagingData

    init(map: Mapper, valuesKey: String) throws {
        try pagingData = map.from("")
        try values = map.from(valuesKey)
    }
}

extension PagingData: Mappable {
    init(map: Mapper) throws {
        try startAt = map.from(Keys.startAt)
        try maxResults = map.from(Keys.maxResults)
        try isLast = map.from(Keys.isLast)
        total = map.optionalFrom(Keys.total)
    }
}

extension PagingData {
    struct Keys {
        static let startAt = "startAt"
        static let maxResults = "maxResults"
        static let isLast = "isLast"
        static let total = "total"
    }
}
