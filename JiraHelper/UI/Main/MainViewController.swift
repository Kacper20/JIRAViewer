//
//  RootViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16.02.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation
import RxSwift

final class MainViewController: NSViewController {

    private let textInputController: TextInputViewController
    private let sprintViewController: SprintViewController
    private let mainViewModel: MainViewModel
    private let disposeBag = DisposeBag()

    private var loadingVC: MainLoadingViewController?

    init(mainViewModel: MainViewModel) {
        textInputController = TextInputViewController()
        sprintViewController = SprintViewController(sprintViewModel: mainViewModel.sprintViewModel)
        self.mainViewModel = mainViewModel
        super.init(nibName: nil, bundle: nil)!

        setupChildVCs()
        setupEventsObserving()
    }

    override func loadView() {
        let view = NSView()
        view.wantsLayer = true
        view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        self.view = view
    }

    private func setupChildVCs() {
        //TODO: Try to refactor this into some container?
        addChildViewController(textInputController)
        view.addSubview(textInputController.view)
        let textInputView = textInputController.view
        textInputView.topToSuperview()
        textInputView.leadingToSuperview()
        textInputView.trailingToSuperview()
        textInputView.heightAnchor.constraint(equalToConstant: 100).activate()
        addChildViewController(sprintViewController)
        view.addSubview(sprintViewController.view)

        let sprintView = sprintViewController.view
        sprintView.topAnchor.constraint(equalTo: textInputController.view.bottomAnchor).activate()
        sprintView.bottomToSuperview()
        sprintView.leadingToSuperview()
        sprintView.trailingToSuperview()
        sprintView.heightAnchor.constraint(equalToConstant: 400).activate()
        //TODO: Has to be computed dynamically, computation should be done by layout preferably. Also 
        sprintView.widthAnchor.constraint(equalToConstant: 945).activate()
    }

    private func setupEventsObserving() {
        mainViewModel.eventsReceiver
            .loadingRequests
            .asObservable()
            .subscribe(onNext: { [unowned self] isVisible in
                self.setLoadingVisibility(isVisible: isVisible)
            }).disposed(by: disposeBag)
    }

    //TODO: We could move it to some kind of presenter
    private func setLoadingVisibility(isVisible: Bool) {
        if isVisible {
            guard loadingVC == nil else { return }
            let vc = MainLoadingViewController()
            addChildViewController(vc)
            view.addSubview(vc.view)
            vc.view.constraintEdgesToSuperview()
            vc.view.alphaValue = 0.0
            animateLoadingView(vc.view, shouldBeVisible: true)
            self.loadingVC = vc
        } else {
            guard let loadingVC = loadingVC else { return }
            animateLoadingView(loadingVC.view, shouldBeVisible: false, completion: {
                loadingVC.view.removeFromSuperview()
                self.loadingVC = nil
            })
        }
    }

    private func animateLoadingView(_ view: NSView, shouldBeVisible: Bool, completion: (() -> Void)? = nil) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1.0
            let desiredAlpha: CGFloat = shouldBeVisible ? 1.0 : 0.0
            view.alphaValue = desiredAlpha
        }, completionHandler: completion)
    }

    override var acceptsFirstResponder: Bool {
        return true
    }

    func processKeyUpEvent(_ event: NSEvent) {
        sprintViewController.upEventsObserver.onNext(event)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
