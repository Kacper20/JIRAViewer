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
    private let imageDownloader: ImageDownloader

    init(issue: Issue, imageDownloader: ImageDownloader) {
        self.issue = issue
        self.imageDownloader = imageDownloader
        super.init(nibName: nil, bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let downloader = imageDownloader
        view = IssueDetailsView(
            data: IssueDetailsViewData(issue: issue),
            urlImageConversion: downloader.getImage(from:)
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        // Do view setup here.
    }
    
}
