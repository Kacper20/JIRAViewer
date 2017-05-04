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
        addChildViewController(textInputController)
        view.addSubview(textInputController.view)
        textInputController.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        addChildViewController(sprintViewController)
        view.addSubview(sprintViewController.view)
        sprintViewController.view.snp.makeConstraints { make in
            make.top.equalTo(textInputController.view.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(300)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
