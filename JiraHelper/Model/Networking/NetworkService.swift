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
    case respons
    case networkUnreachable
    case invalidStatusCode(code: Int, response: [String : AnyObject]?)
}

final class NetworkService {

    private let manager: SessionManager
    private let networkLogger: NetworkLogger
    private let decoder = JSONDecoder()

    init() {
        networkLogger = NetworkLogger()
        let configuration = URLSessionConfiguration.default
        manager = SessionManager(configuration: configuration)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.dataDecodingStrategy = .custom(<#T##(Decoder) throws -> Data#>)
    }

    func request<T>(
        basePath: String,
        configuration: EndpointConfiguration<T>)
        -> Observable<T> {
        let path = basePath + configuration.path
        networkLogger.logRequest(path: path, configuration: configuration)
        return Observable.create { [weak self] observer in
            guard let `self` = self else { return Disposables.create() }
            let request = self.manager.request(
                path,
                method: configuration.method,
                parameters: configuration.parameters,
                encoding: configuration.encoding,
                headers: configuration.headers
            )
            .responseJSON { [weak self] response in
                self?.handleResponse(configuration: configuration, response: response, observer: observer)
            }
            return Disposables.create {
                request.cancel()
            }
        }
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
