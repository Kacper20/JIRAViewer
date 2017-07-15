//
//  MainWindowPopoverPresenter.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 10/07/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

final class MainWindowPopoverPresenter: NSObject, NSPopoverDelegate {
    private var popover: NSPopover?

    override init() {
        var mask = NSWindowStyleMask.titled
        mask.insert(.closable)
    }

    private var window: NSWindow?
    func present(request: IssueExpandRequest, imageDownloader: ImageDownloader) {
        let loading = LoadingPerformingFlowViewController(
            operation: request.operation,
            controllerConstruction: { issue in
                return IssueDetailsViewController(issue: issue, imageDownloader: imageDownloader)
        })
        loading.view.heightAnchor.constraint(equalToConstant: 500).activate()
        loading.view.widthAnchor.constraint(equalToConstant: 300).activate()

        self.popover?.close()
        let popover = NSPopover()
        self.popover = popover
        popover.behavior = .transient
        popover.appearance = NSAppearance(named: NSAppearanceNameVibrantLight)
        popover.animates = true
        popover.contentViewController = loading
        popover.delegate = self
        popover.show(relativeTo: request.rect, of: request.source, preferredEdge: .maxX)
    }

    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return true
    }
}
