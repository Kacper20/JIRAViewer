//
//  PagedEndpointConverter.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct PagedEndpointConverter {

    static func convert<T>(
        configuration: EndpointConfiguration<ArrayOfValuesWithPagingData<T>>,
        index: Int,
        limit: Int
        ) -> EndpointConfiguration<ArrayOfValuesWithPagingData<T>> {
        fatalError("Not implemented")
    }
}
