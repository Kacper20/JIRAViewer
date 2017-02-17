//
// Created by Kacper Harasim on 16.02.2017.
// Copyright (c) 2017 Kacper Harasim. All rights reserved.
//

import AppKit

final class TextInputViewController: NSViewController {

    @IBOutlet weak var inputTextField: NSTextField! {
        didSet {
            TextFieldStyles.mainInput.apply(to: inputTextField)
        }
    }

    init() {
        super.init(nibName: "TextInputViewController", bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
