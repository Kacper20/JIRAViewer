//
// Created by Kacper Harasim on 16.02.2017.
// Copyright (c) 2017 Kacper Harasim. All rights reserved.
//

import SnapKit
import AppKit
import RxSwift

final class MainWindowController: NSWindowController {

    @IBOutlet weak var toolbar: NSToolbar!

    private let disposeBag = DisposeBag()
    private let mainViewModelCreator: MainViewStartDataService

    private var mainViewController: MainViewController?

    override var windowNibName : String! {
        return "MainWindowController"
    }

    init(mainViewModelCreator: MainViewModelCreator) {
        self.mainViewModelCreator = mainViewModelCreator
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    func present() {
        return mainV
    }

    private func presentVC(with viewModel: MainViewModel) {
        let mainViewController = MainViewController()
        self.mainViewController = mainViewController
        window?.contentView?.addSubview(mainViewController.view)
        mainViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        window?.makeKey()

        configureToolbar()
    }

    private func configureToolbar() {
//        toolbar.allowsUserCustomization = true
//        toolbar.autosavesConfiguration = true
    }
}
