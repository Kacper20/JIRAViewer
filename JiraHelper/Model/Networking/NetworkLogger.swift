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
        logger.info("REQUEST:")
        logger.info("URL: \(path):")
        logger.info("HTTP METHOD: \(configuration.method.rawValue):")
        let headers = configuration.headers
        let parameters = configuration.parameters
        logger.info("HEADERS: \(prettyPrintedDict(from: headers) ?? headers.description)")
        logger.info("PARAMETERS: \(prettyPrintedDict(from: parameters) ?? parameters.description)")
    }


    func logResponse(_ response: Alamofire.DataResponse<Any>) {
        logger.info("RESPONSE:")
        guard let httpResponse = response.response else {
            logger.info("ERROR: Response not found")
            return
        }
        logger.info("HTTP CODE: \(httpResponse.statusCode)")
        if let responseValue = response.result.value, !(responseValue is NSNull),
           let dictReadable = prettyPrintedDict(from: responseValue) {
            logger.info("JSON BODY: \(dictReadable)")
        } else if let data = response.data {
            let body = String(data: data, encoding: String.Encoding.utf8)
            logger.info("BODY: \(body.debugDescription)")
        }
    }

    private func prettyPrintedDict(from object: Any) -> String? {
        if let data = try? JSONSerialization.data(
            withJSONObject: object, options: [.prettyPrinted]),
            let dictAsString = String(data: data, encoding: .utf8){
            return dictAsString
        }
        return nil
    }
}
