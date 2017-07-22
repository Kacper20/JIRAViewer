//
// Created by Kacper Harasim on 16.02.2017.
// Copyright (c) 2017 Kacper Harasim. All rights reserved.
//

import AppKit
import RxSwift

final class TextInputViewController: NSViewController {

    private let commandInterpreter: CommandTextInterpretable
    private let disposeBag = DisposeBag()

    @IBOutlet weak var inputTextField: NSTextField! {
        didSet {
            TextFieldStyles.mainInput.apply(to: inputTextField)
        }
    }

    init(commandInterpreter: CommandTextInterpretable) {
        self.commandInterpreter = commandInterpreter
        super.init(nibName: "TextInputViewController", bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
        subscribeToEvents()
    }

    private func subscribeToEvents() {
        inputTextField.rx.text
            .asObservable()
            .filterNils()
            .subscribe(onNext: { [unowned self] text in
                self.commandInterpreter.interpret(text: text)
            })
            .disposed(by: disposeBag)
    }
}
