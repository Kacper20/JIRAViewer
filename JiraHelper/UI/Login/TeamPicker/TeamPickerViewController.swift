//
//  TeamPickerViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 07.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa
import Foundation
import AppKit

enum TeamPickerAction {
    case teamPicked(JIRATeam)
}

final class TeamPickerViewController: NSViewController {
    
    @IBOutlet weak var inputPicker: NSTextField!
    @IBOutlet weak var processButton: NSButton!

    private let disposeBag = DisposeBag()

    private let viewModel: TeamPickerViewModel
    private let actionHandler: (TeamPickerAction) -> Void

    init(viewModel: TeamPickerViewModel, actionHandler: @escaping (TeamPickerAction) -> Void) {
        self.viewModel = viewModel
        self.actionHandler = actionHandler
        super.init(nibName: String(describing: TeamPickerViewController.self), bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var viewStateSink: AnyObserver<TeamPickerViewState> {
        return AnyObserver { [weak self] event in
            guard let `self` = self else { return }
            switch event {
            case .completed:
                self.actionHandler(.teamPicked(self.viewModel.pickedTeam))
            default: break
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.isValid
            .bind(to: processButton.rx.isEnabled)
            .disposed(by: disposeBag)

        (inputPicker.rx.text <-> viewModel.teamName).disposed(by: disposeBag)

        processButton.rx.tap
            .flatMap { [unowned self] in self.viewModel.proceedWithRequest() }
            .bind(to: viewStateSink)
            .disposed(by: disposeBag)
    }
}
