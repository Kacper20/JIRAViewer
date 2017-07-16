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

        let popoverToUse: NSPopover
        if let popover = popover {
            popoverToUse = popover
        } else {
            popoverToUse = NSPopover()
        }
        self.popover = popoverToUse
        popoverToUse.behavior = .transient
        popoverToUse.appearance = NSAppearance(named: NSAppearanceNameVibrantLight)
        popoverToUse.animates = true
        popoverToUse.contentViewController = loading
        popoverToUse.delegate = self
        popoverToUse.show(relativeTo: request.rect, of: request.source, preferredEdge: .maxX)
    }

    func popoverDidClose(_ notification: Notification) {
        self.popover = nil
    }

    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return true
    }
}
