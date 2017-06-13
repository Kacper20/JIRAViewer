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
    private let authenticatedNetworkService: AuthenticatedNetworkService
    //TODO: Injected?
    private let boardsService: BoardService
    
    private var mainViewController: MainViewController?

    override var windowNibName : String! {
        return "MainWindowController"
    }

    init(authenticatedNetworkService: AuthenticatedNetworkService) {
        self.authenticatedNetworkService = authenticatedNetworkService
        self.boardsService = BoardService(networkService: authenticatedNetworkService)
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    func present() {

        //TODO: Kanban boards only for now
        boardsService
            .boards()
            .subscribe(onNext: { [unowned self] boards in
                print(boards)
                self.presentVC()
            }, onError: { error in

            }).disposed(by: disposeBag)
    }

    private func presentVC() {
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
