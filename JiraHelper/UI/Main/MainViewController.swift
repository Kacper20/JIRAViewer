//
//  RootViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16.02.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class MainViewController: NSViewController {

    private let textInputController: TextInputViewController
    private let sprintViewController: SprintViewController

    init(mainViewModel: MainViewModel) {
        textInputController = TextInputViewController()
        sprintViewController = SprintViewController(sprintViewModel: mainViewModel.sprintViewModel)
        super.init(nibName: nil, bundle: nil)!

        setupChildVCs()
    }

    override func loadView() {
        view = NSView()
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
