//
// Created by Kacper Harasim on 16.02.2017.
// Copyright (c) 2017 Kacper Harasim. All rights reserved.
//

import SnapKit
import AppKit

final class MainWindowController: NSWindowController {

    private var mainViewController: MainViewController?

    override var windowNibName : String! {
        return "MainWindow"
    }

    convenience init() {
        self.init(window: nil)
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        let mainViewController = MainViewController()
        self.mainViewController = mainViewController
        window?.contentView?.addSubview(mainViewController.view)
        mainViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
