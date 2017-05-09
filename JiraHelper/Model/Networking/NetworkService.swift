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
}

final class NetworkService {

    private let manager: SessionManager

    init() {
        let configuration = URLSessionConfiguration.default
        manager = SessionManager(configuration: configuration)
    }

    func request<T>(
        basePath: String,
        configuration: EndpointConfiguration<T>)
        -> Observable<T> {
        let path = basePath + configuration.path
        logRequest(path: basePath, configuration: configuration)
        return Observable.create { [weak self] observer in
            guard let `self` = self else { return Disposables.create() }
            let request = self.manager.request(
                path,
                method: configuration.method,
                parameters: configuration.parameters,
                encoding: configuration.encoding,
                headers: configuration.headers
            )
            .validate(statusCode: 200...299)
            .responseJSON { [weak self] response in
                self?.logResponse(response)
                if let data = response.data {
                    switch configuration.resourceType {
                    case .fromData(generation: let generationFunc):
                        self?.parseResourceAndNotifyObserver(
                            observer: observer,
                            data: data,
                            resourceGeneration: generationFunc
                        )
                    case .fromDictionary(generation: let generationFunc):
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                            let dict = json as? [String : AnyObject] {
                            self?.parseResourceAndNotifyObserver(
                                observer: observer,
                                data: dict,
                                resourceGeneration: generationFunc
                            )
                        } else {
                            //TODO: Errors
                        }
                    }
                } else {
                    //TODO: Errors
                }
            }
            return Disposables.create {
                request.cancel()
            }
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

    private func logRequest<T>(path: String, configuration: EndpointConfiguration<T>) {

    }

    private func logResponse(_ response: Alamofire.DataResponse<Any>) {

    }
}
