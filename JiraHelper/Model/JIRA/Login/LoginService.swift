//
//  LoginService.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 03.06.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginService {
    associatedtype Result

    func login(with data: LoginData) -> Observable<Result>
}
