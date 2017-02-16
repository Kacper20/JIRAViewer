//
//  RootViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16.02.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class MainViewController: NSViewController {
    init() {
        super.init(nibName: nil, bundle: nil)!
        setupTextInputVC()
    }

    override func loadView() {
        view = NSView()
    }

    private func setupTextInputVC() {
        let controller = TextInputViewController()
        controller.addChildViewController(controller)
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        controller.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
