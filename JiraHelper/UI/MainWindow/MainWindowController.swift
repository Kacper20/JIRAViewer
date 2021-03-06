//
// Created by Kacper Harasim on 16.02.2017.
// Copyright (c) 2017 Kacper Harasim. All rights reserved.
//
import AppKit
import RxSwift

enum MainWindowAction {
    case logout
    case changeTeam(newTeam: JIRATeam)
    case addNewTeam
}

final class MainWindowController: NSWindowController {

    @IBOutlet weak var toolbar: NSToolbar!

    private let disposeBag = DisposeBag()
    private let actionHandler: (MainWindowAction) -> Void
    private let mainViewModelCreator: MainViewModelCreator
    private let popoverPresenter = MainWindowPopoverPresenter()

    private var mainViewController: MainViewController?
    private var toolbarManager: MainWindowToolbarManager?
    private var menuManager: MainWindowMenuManager?

    override var windowNibName : String! {
        return "MainWindowController"
    }

    init(mainViewModelCreator: MainViewModelCreator, actionHandler: @escaping (MainWindowAction) -> Void) {
        self.mainViewModelCreator = mainViewModelCreator
        self.actionHandler = actionHandler
        super.init(window: nil)
    }

    deinit {
        menuManager?.clearItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    @objc private func handleTeamAdding() {
        actionHandler(.addNewTeam)
    }

    @objc private func handleTeamChanging(sender: AnyObject) {
        if let item = sender as? NSMenuItem, let team = menuManager?.matchMenuItemToTeam(item: item) {
            actionHandler(.changeTeam(newTeam: team))
        }
    }

    @objc private func handleLogout() {
        actionHandler(.logout)
    }

    override func keyDown(with event: NSEvent) { }

    override func keyUp(with event: NSEvent) {
        mainViewController?.processKeyUpEvent(event)
    }

    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        return true
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
        setupMenuItemsManager(teams: viewModel.otherTeams)
        let mainViewController = MainViewController(mainViewModel: viewModel)
        self.mainViewController = mainViewController
        window?.contentView?.addSubview(mainViewController.view)
        mainViewController.view.constraintEdgesToSuperview()
        configureToolbarManager(boardsChoice: viewModel.boardsChoice, sprintChoice: viewModel.sprintChoice)
        window?.makeKey()
    }

    private func setupMenuItemsManager(teams: [JIRATeam]) {
        if let menu = NSApp.menu {
            menuManager = MainWindowMenuManager(
                menu: menu,
                logoutAction: MenuItemAction(target: self, selector: #selector(MainWindowController.handleLogout)),
                addTeamAction: MenuItemAction(target: self, selector: #selector(MainWindowController.handleTeamAdding)),
                teamsInfo: TeamSwitchItemsInfo(
                    teams: teams,
                    target: self,
                    selector: #selector(MainWindowController.handleTeamChanging(sender:))
                )
            )
        }
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
