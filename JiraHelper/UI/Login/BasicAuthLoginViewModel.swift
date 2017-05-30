//
//  BasicAuthLoginViewModel.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class BasicAuthLoginViewModel {
    private let service: BasicAuthLoginService

    init(service: BasicAuthLoginService) {
        self.service = service
    }

}
