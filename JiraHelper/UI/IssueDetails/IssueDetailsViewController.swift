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
        view = IssueDetailsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.cgColor
        // Do view setup here.
    }
    
}
