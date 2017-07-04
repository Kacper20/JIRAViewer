//
//  LoadingPerformingViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 04/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class LoadingPerformingFlowViewController<T>: LoadingContainerViewController {

    private let operationDisposeBox = SerialDisposeBox()
    private let operation: Observable<T>
    private let controllerConstruction: (T) -> NSViewController

    init(
        operation: Observable<T>,
        controllerConstruction: @escaping (T) -> NSViewController
        ) {
        self.operation = operation
        self.controllerConstruction = controllerConstruction
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        performLoading()
    }

    private func performLoading() {
        let loadingVC = LoadingContentViewController()
        presentViewController(loadingVC)
        operationDisposeBox.disposable = operation
            .subscribe(onNext: { [unowned self] value in
                let vc = self.controllerConstruction(value)
                self.presentViewController(vc)
                }, onError: { [unowned self] error in
                    self.presentError(error)
            })
    }

    private func presentError(_ error: Error) {
        fatalError("Not implemented yet")
    }
}
