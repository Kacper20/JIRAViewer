//
//  Serialization.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 11/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

extension Decodable {
    init(data: [String : Any]) throws {
        let decoder = JSONDecoder()
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        self = try decoder.decode(Self.self, from: jsonData)
    }
}
