//
//  NetworkService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

enum NetworkServiceError: Error {
    case parsingError(Error)
    case networkUnreachable
    case invalidStatusCode(code: Int, response: [String : AnyObject]?)
    case requestCreationError(Error)
}

enum RequestCreationError: Error {
    case incorrectPath
    case objectNotEncodable
}

struct EncodableBox: Encodable {
    private let encodable: Encodable

    init(encodable: Encodable) {
        self.encodable = encodable
    }
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

final class NetworkService {

    private let manager: SessionManager
    private let networkLogger: NetworkLogger
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    init() {
        networkLogger = NetworkLogger()
        let configuration = URLSessionConfiguration.default
        manager = SessionManager(configuration: configuration)
        setupDecoder()
    }

    private func setupDecoder() {
        let formatter = DateFormatter()
//        let formatter = DateFormatter()
        decoder.dateDecodingStrategy = .custom { decoder in
            let formats = [
                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                "dd/MMM/yy h:mm a",
                "EEEE h:mm a"
            ]
            let container = try decoder.singleValueContainer()
            let stringValue = try container.decode(String.self)

            let date = formats.lazy.flatMap { format -> Date? in
                formatter.dateFormat = format
                return formatter.date(from: stringValue)
            }.first
            guard let dateFormatted = date else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "None of the date formatters provided were correct for: \(stringValue)"
                    )
                )
            }
            return dateFormatted
        }
    }

    func request<T>(
        basePath: String,
        configuration: EndpointConfiguration<T>)
        -> Observable<T> {
        let path = basePath + configuration.path
        networkLogger.logRequest(path: path, configuration: configuration)
        return Observable.create { [weak self] observer in
            guard let `self` = self else { return Disposables.create() }
            let request: DataRequest

            switch configuration.parameters {
            case let .dict(dict):
                request = self.manager.request(
                    path,
                    method: configuration.method,
                    parameters: dict,
                    encoding: configuration.encoding,
                    headers: configuration.headers
                )
            case let .object(object):
                do {
                    let box = EncodableBox(encodable: object)
                    let urlRequest = try self.customRequest(
                        path: path,
                        method: configuration.method,
                        object: box,
                        headers: configuration.headers.merging(
                            ["Content-Type" : "application/json"], uniquingKeysWith: { (current, _) in current }
                        )
                    )
                    request = self.manager.request(urlRequest)
                } catch {
                    observer.onError(NetworkServiceError.requestCreationError(error))
                    return Disposables.create()
                }
            }
            request.responseJSON { [weak self] response in
                self?.handleResponse(configuration: configuration, response: response, observer: observer)
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    private func customRequest<T: Encodable>(
        path: String,
        method: Alamofire.HTTPMethod,
        object: T,
        headers: [String : String]
        ) throws -> URLRequest {
        guard let url = URL(string: path) else { throw RequestCreationError.incorrectPath }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        request.httpBody = try encoder.encode(object)
        request.allHTTPHeaderFields = headers
        return request
    }

    private func handleResponse<Resource>(
        configuration: EndpointConfiguration<Resource>,
        response: Alamofire.DataResponse<Any>,
        observer: AnyObserver<Resource>
        ) {
        networkLogger.logResponse(response)
        guard let code = response.response?.statusCode else {
            observer.onError(NetworkServiceError.networkUnreachable)
            return
        }
        guard code >= 200 && code <= 299 else {
            observer.onError(NetworkServiceError.invalidStatusCode(
                code: code,
                response: response.result.value as? [String : AnyObject]
            ))
            return
        }
        if let data = response.data {
            switch configuration.resourceType {
            case .json:
                parseResourceAndNotifyObserver(
                    observer: observer,
                    data: data,
                    resourceGeneration: {
                        try self.decoder.decode(Resource.self, from: $0)
                    }
                )
            case let .none(value):
                observer.onNext(value)
                observer.onCompleted()
            }
        } else {
            //TODO: Errors
        }
    }

    private func parseResourceAndNotifyObserver<T, Y>(
        observer: AnyObserver<T>,
        data: Y,
        resourceGeneration: (Y) throws -> T) {
        do {
            let object = try resourceGeneration(data)
            observer.onNext(object)
            observer.onCompleted()
        } catch {
            observer.onError(error)
        }
    }
}
