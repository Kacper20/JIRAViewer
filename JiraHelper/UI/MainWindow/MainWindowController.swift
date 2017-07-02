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
    private var toolbarManager: MainWindowToolbarManager?

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

    override func keyDown(with event: NSEvent) { }

    override func keyUp(with event: NSEvent) {
        mainViewController?.processKeyUpEvent(event)
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
        let mainViewController = MainViewController(mainViewModel: viewModel)
        self.mainViewController = mainViewController
        window?.contentView?.addSubview(mainViewController.view)
        mainViewController.view.constraintEdgesToSuperview()
        configureToolbarManager(boardsChoice: viewModel.boardsChoice, sprintChoice: viewModel.sprintChoice)

        window?.makeKey()
    }

    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        return NSTouchBar()
    }

    private func configureToolbarManager(boardsChoice: BoardsChoice, sprintChoice: ActiveSprintChoice) {
        toolbarManager = MainWindowToolbarManager(toolbar: toolbar, boardsChoice: boardsChoice, sprintChoice: sprintChoice)
        if #available(OSX 10.12.2, *), let touchBar = touchBar {
            toolbarManager?.setupTouchBar(touchBar: touchBar)
        }
    }
}
