//
//  MainLoadingViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 02/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Cocoa

class LoadingContentViewController: NSViewController {

    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var box: NSBox!

    init() {
        super.init(nibName: String(describing: LoadingContentViewController.self), bundle: nil)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        progressIndicator.startAnimation(nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

final class DisabledView: NSView {

    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
}
