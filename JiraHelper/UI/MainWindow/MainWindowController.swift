//
// Created by Kacper Harasim on 16.02.2017.
// Copyright (c) 2017 Kacper Harasim. All rights reserved.
//
import AppKit
import RxSwift

final class MainWindowController: NSWindowController {

    @IBOutlet weak var toolbar: NSToolbar!

    private let disposeBag = DisposeBag()
    private let mainViewModelCreator: MainViewModelCreator

    private var mainViewController: MainViewController?
    private var toolbarManager: ToolbarManager?

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
        mainViewModelCreator
            .create()
            .subscribe(onNext: { [unowned self] viewModel in
                self.presentVC(with: viewModel)
            }, onError: { [unowned self] error in
                Logger.shared.error("Error occured: \(error)")
            }).disposed(by: disposeBag)
    }

    private func presentVC(with viewModel: MainViewModel) {
        let mainViewController = MainViewController()
        self.mainViewController = mainViewController
        window?.contentView?.addSubview(mainViewController.view)
        mainViewController.view.constraintEdgesToSuperview()
        configureToolbar(boardsChoice: viewModel.boardsChoice, sprintChoice: viewModel.sprintChoice)
        window?.makeKey()
    }

    private func configureToolbar(boardsChoice: BoardsChoice, sprintChoice: ActiveSprintChoice) {
        toolbarManager = ToolbarManager(toolbar: toolbar, boardsChoice: boardsChoice, sprintChoice: sprintChoice)
    }
}