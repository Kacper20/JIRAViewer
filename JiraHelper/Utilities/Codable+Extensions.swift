//
//  Codable+Extensions.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 18/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

enum CodingError: Error {
    case serializationFailed
}

extension Decodable {
    init(dict: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: dict, options: [])
        let decoder = JSONDecoder()
        let type = try decoder.decode(Self.self, from: data)
        self = type
    }
}

extension Encodable {
    func getDict() throws -> [String: Any] {
        let encoder = JSONEncoder()
        let result = try encoder.encode(self)
        let data = try JSONSerialization.jsonObject(with: result, options: [])
        guard let dict =  data as? [String: Any] else {
            throw CodingError.serializationFailed
        }
        return dict
    }
}
