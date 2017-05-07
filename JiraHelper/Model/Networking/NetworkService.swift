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

final class NetworkService {
    enum Error {
        case parsingError(Swift.Error)
        case respons
    }

    private let manager: SessionManager

    init() {
        let configuration = URLSessionConfiguration.default
        manager = SessionManager(configuration: configuration)
    }

    func request<T>(
        basePath: String,
        configuration: EndpointConfiguration,
        parse: @escaping ([String : AnyObject]) -> T?)
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
                if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: []),
                   let dict = json as? [String : AnyObject], let result = parse(dict) {
                    observer.onNext(result)
                    observer.onCompleted()
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    private func logRequest(path: String, configuration: EndpointConfiguration) {

    }

    private func logResponse(_ response: Alamofire.DataResponse<Any>) {

    }
}
