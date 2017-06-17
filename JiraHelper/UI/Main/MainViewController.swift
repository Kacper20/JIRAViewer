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

    init() {
        textInputController = TextInputViewController()
        sprintViewController = SprintViewController()
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
        textInputController.view.constraintWithSuperview { (view, parent) in
            view.topAnchor.constraint(equalTo: parent.topAnchor).activate()
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor).activate()
            view.trailingAnchor.constraint(equalTo: parent.trailingAnchor).activate()
            view.heightAnchor.constraint(equalToConstant: 100).activate()
        }
        addChildViewController(sprintViewController)
        view.addSubview(sprintViewController.view)
        sprintViewController.view.constraintWithSuperview { (view, parent) in
            view.topAnchor.constraint(equalTo: textInputController.view.bottomAnchor).activate()
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor).activate()
            view.trailingAnchor.constraint(equalTo: parent.trailingAnchor).activate()
            view.heightAnchor.constraint(equalToConstant: 400).activate()
            view.widthAnchor.constraint(equalToConstant: 700).activate()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
