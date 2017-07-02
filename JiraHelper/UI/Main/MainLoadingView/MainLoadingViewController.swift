//
//  MainLoadingViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 02/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Cocoa

class MainLoadingViewController: NSViewController {

    init() {
        super.init(nibName: String(describing: MainLoadingViewController.self), bundle: nil)!
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
