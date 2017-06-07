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
    let isLast: Bool
    let total: Int?
}

struct ArrayOfValuesWithPagingData<T: Codable>: Codable {
    let values: [T]
    let pagingData: PagingData
}
