//
//  AppLifecycleMonitor.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 27.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class AppLifecycleMonitor {

    var didBecomeActive: Observable<Void> {
        return NotificationCenter.default
            .rx.notification(NSNotification.Name.NSApplicationDidBecomeActive)
            .asObservable()
            .discardType()
    }
}
