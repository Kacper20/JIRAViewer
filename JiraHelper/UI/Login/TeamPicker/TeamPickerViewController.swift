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

final class TeamPickerViewController: NSViewController {
    
    @IBOutlet weak var inputPicker: NSTextField!
    @IBOutlet weak var processButton: NSButton!

    private let disposeBag = DisposeBag()

    private let viewModel: TeamPickerViewModel

    init(viewModel: TeamPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TeamPickerViewController.self), bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {

        viewModel.isValid
            .bind(to: processButton.rx.isEnabled)
            .disposed(by: disposeBag)

        inputPicker.rx.text
            .asObservable()
            .filterNils()
            .bind(to: viewModel.teamName)
            .disposed(by: disposeBag)

        processButton.rx.tap
            .flatMap {  }
    }
}
