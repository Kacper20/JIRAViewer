//
//  AppDelegate.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 25.01.2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var rootFlowController: RootFlowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        let shortcut = MASShortcut(keyCode: UInt(kVK_F9), modifierFlags: NSEventModifierFlags.command.rawValue)
//        MASShortcutMonitor.shared().register(shortcut, withAction: { [unowned self] in
//            if NSApp.isActive {
//                self.windowController?.window?.orderOut(nil)
//            } else {
//                self.windowController?.window?.makeKeyAndOrderFront(nil)
//            }
//        })
        let networkService = NetworkService()
        let authenticationProvider = AuthenticationProvider()
        rootFlowController = RootFlowController(
            networkService: networkService,
            authenticationProvider: authenticationProvider
        )
        rootFlowController?.present()

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationDidResignActive(_ notification: Notification) {
//        windowController?.window?.orderOut(nil)
    }
}

