//
//  RequestConfiguration.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import Alamofire

typealias NetworkRequestMethod = Alamofire.HTTPMethod
typealias NetworkRequestParameterEncoding = Alamofire.ParameterEncoding
typealias JSONEncoding = Alamofire.JSONEncoding
typealias URLEncoding = Alamofire.URLEncoding

class Nothing: Codable { }

struct EndpointConfiguration<Resource: Decodable> {
    enum ResourceOrigin {
        indirect case none(Resource)
        case json
    }

    let path: String
    let method: NetworkRequestMethod
    let encoding: NetworkRequestParameterEncoding
    var headers: [String : String]
    let parameters: [String : AnyObject]
    let resourceType: ResourceOrigin
}
