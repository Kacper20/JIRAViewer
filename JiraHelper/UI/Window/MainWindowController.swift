//
// Created by Kacper Harasim on 16.02.2017.
// Copyright (c) 2017 Kacper Harasim. All rights reserved.
//

import SnapKit
import AppKit

final class MainWindowController: NSWindowController {

    @IBOutlet weak var visualEffectView: NSVisualEffectView!
    
    private var mainViewController: MainViewController?

    override var windowNibName : String! {
        return "MainWindowController"
    }

    convenience init() {
        self.init(window: nil)
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        visualEffectView.state = .active
        visualEffectView.material = .mediumLight
        visualEffectView.maskImage = MaskImage.create(withRadius: 18)

        let mainViewController = MainViewController()
        self.mainViewController = mainViewController
        window?.contentView?.addSubview(mainViewController.view)
        mainViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
