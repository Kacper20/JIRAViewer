//
// Created by Kacper Harasim on 16.02.2017.
// Copyright (c) 2017 Kacper Harasim. All rights reserved.
//
import AppKit
import RxSwift

enum MainWindowAction {
    case logoutClicked
}

final class MainWindowController: NSWindowController {

    @IBOutlet weak var toolbar: NSToolbar!

    private let disposeBag = DisposeBag()
    private let actionHandler: (MainWindowAction) -> Void
    private let mainViewModelCreator: MainViewModelCreator
    private let popoverPresenter = MainWindowPopoverPresenter()

    private var mainViewController: MainViewController?
    private var toolbarManager: MainWindowToolbarManager?

    override var windowNibName : String! {
        return "MainWindowController"
    }

    init(mainViewModelCreator: MainViewModelCreator, actionHandler: @escaping (MainWindowAction) -> Void) {
        self.mainViewModelCreator = mainViewModelCreator
        self.actionHandler = actionHandler
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        setupLogoutMenuItem()
    }

    override func keyDown(with event: NSEvent) { }

    override func keyUp(with event: NSEvent) {
        mainViewController?.processKeyUpEvent(event)
    }

    //MENU Manager - needs to keep them separate
    private func setupLogoutMenuItem() {
        guard let menu = NSApp.mainMenu else { return }
        let item = NSMenuItem(
            title: "",
            action: #selector(MainWindowController.logoutClicked),
            keyEquivalent: ""
        )
        let settingsMenu = NSMenu(title: "Account")
        settingsMenu.insertItem(
            withTitle: "Logout",
            action: #selector(MainWindowController.logoutClicked),
            keyEquivalent: "",
            at: 0
        )
        item.submenu = settingsMenu
        menu.insertItem(item, at: 1)
        print(menu.items)
    }

    @objc private func logoutClicked() {
        actionHandler(.logoutClicked)
    }

    func present() {
        mainViewModelCreator
            .create()
            .subscribe(onNext: { [unowned self] viewModel in
                self.presentVC(with: viewModel)
                self.subscribeToIssueDetailsPresentations(viewModel: viewModel)
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

    private func subscribeToIssueDetailsPresentations(viewModel: MainViewModel) {
        viewModel.sprintViewModel
            .issueDetailsExpand
            .subscribe(onNext: { [unowned self] request in
                self.popoverPresenter.present(request: request, imageDownloader: viewModel.imageDownloader)
            }).addDisposableTo(disposeBag)
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
