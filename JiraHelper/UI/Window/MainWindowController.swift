//
// Created by Kacper Harasim on 16.02.2017.
// Copyright (c) 2017 Kacper Harasim. All rights reserved.
//

import SnapKit
import AppKit

final class MainWindowController: NSWindowController {

    @IBOutlet weak var toolbar: NSToolbar!

    private let authenticatedNetworkService: AuthenticatedNetworkService
    //TODO: Should be injected
    
    private var mainViewController: MainViewController?

    override var windowNibName : String! {
        return "MainWindowController"
    }

    init(authenticatedNetworkService: AuthenticatedNetworkService) {
        self.authenticatedNetworkService = authenticatedNetworkService
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    func present() {
        let mainViewController = MainViewController()
        self.mainViewController = mainViewController
        window?.contentView?.addSubview(mainViewController.view)
        mainViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        configureToolbar()
    }

    private func configureToolbar() {
//        toolbar.allowsUserCustomization = true
//        toolbar.autosavesConfiguration = true
    }

    func present() {
        window?.makeKey()
    }
}
