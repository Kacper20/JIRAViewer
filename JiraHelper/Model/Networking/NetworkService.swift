//
//  NetworkService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift
import Mapper
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

    init() {
        networkLogger = NetworkLogger()
        let configuration = URLSessionConfiguration.default
        manager = SessionManager(configuration: configuration)
    }

    func request<T>(
        basePath: String,
        configuration: EndpointConfiguration<T>)
        -> Observable<T> {
        let path = basePath + configuration.path
        networkLogger.logRequest(path: basePath, configuration: configuration)
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
        networkLogger.logResponse(response)
        if let data = response.data {
            switch configuration.resourceType {
            case .data(generation: let generationFunc):
                parseResourceAndNotifyObserver(
                    observer: observer,
                    data: data,
                    resourceGeneration: generationFunc
                )
            case .dictionary(generation: let generationFunc):
                if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                    let dict = json as? [String : AnyObject] {
                    let mapper = Mapper(JSON: dict as NSDictionary)
                    parseResourceAndNotifyObserver(
                        observer: observer,
                        data: mapper,
                        resourceGeneration: generationFunc
                    )
                } else {
                    //TODO: Errors
                }
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
