//
//  NetworkLogger.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 27.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkLogger {
    private let logger = Logger.shared

    func logRequest<T>(path: String, configuration: EndpointConfiguration<T>) {
        logger.info("[REQUEST] URL: \(path):")
        logger.info("[REQUEST] HTTP METHOD: \(configuration.method.rawValue):")
        let headers = configuration.headers
        let parameters = configuration.parameters
        logger.info("[REQUEST] HEADERS: \(prettyPrintedDict(from: headers) ?? headers.description)")
        switch parameters {
        case let .dict(dict):
            logger.info("[REQUEST] PARAMETERS: \(prettyPrintedDict(from: dict) ?? dict.description)")
        case let .object(object):
            logger.info("[REQUEST] OBJECT SEND: \(dump(object))")
        }
    }


    func logResponse(_ response: Alamofire.DataResponse<Any>) {
        guard let httpResponse = response.response else {
            logger.info("[RESPONSE] ERROR: Response not found")
            return
        }
        logger.info("[RESPONSE] HTTP CODE: \(httpResponse.statusCode)")
        if let responseValue = response.result.value, !(responseValue is NSNull),
           let dictReadable = prettyPrintedDict(from: responseValue) {
            logger.info("[RESPONSE] JSON BODY: \(dictReadable)")
        }
    }

    private func prettyPrintedDict(from object: Any) -> String? {
        if (object as? [String : AnyObject])?.isEmpty ?? false || (object as? [Any])?.isEmpty ?? false {
            return "EMPTY"
        }
        if let data = try? JSONSerialization.data(
            withJSONObject: object, options: [.prettyPrinted]),
            let dictAsString = String(data: data, encoding: .utf8){
            return dictAsString
        }
        return nil
    }
}
