//
//  IssueDetailsViewController.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 03/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Cocoa

class IssueDetailsViewController: NSViewController {

    private let issue: Issue

    init(issue: Issue) {
        self.issue = issue
        super.init(nibName: nil, bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = IssueDetailsView(data: IssueDetailsViewData(issue: issue))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        // Do view setup here.
    }
    
}
