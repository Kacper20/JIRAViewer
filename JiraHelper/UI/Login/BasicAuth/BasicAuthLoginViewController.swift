//
//  BasicAuthViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 28.05.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Cocoa

class BasicAuthLoginViewController: NSViewController {

    private let team: JIRATeam
    private let basicAuthViewModel: BasicAuthLoginViewModel

    init(team: JIRATeam, viewModel: BasicAuthLoginViewModel) {
        self.team = team
        self.basicAuthViewModel = viewModel
        super.init(nibName: String(describing: TeamPickerViewController.self), bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
