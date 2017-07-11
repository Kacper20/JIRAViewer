//
//  PagedEndpointConverter.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 17/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct PagedEndpointConverter {
    //TODO: Use Sourcery lenses generator when it'll be supported in Xcode 9
    static func convert<T>(
        configuration: EndpointConfiguration<ArrayOfValuesWithPagingData<T>>,
        index: Int,
        limit: Int
        ) -> EndpointConfiguration<ArrayOfValuesWithPagingData<T>> {
        return EndpointConfiguration(
            path: configuration.path,
            method: configuration.method,
            encoding: configuration.encoding,
            headers: configuration.headers,
            parameters: .dict([
                "start" : index,
                "limit" : limit
            ]),
            resourceType: configuration.resourceType
        )
    }
}
