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


    private var windowController: MainWindowController?


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        windowController = MainWindowController()
        windowController?.window?.makeKey()

        let shortcut = MASShortcut(keyCode: UInt(kVK_F9), modifierFlags: NSEventModifierFlags.command.rawValue)
        MASShortcutMonitor.shared().register(shortcut, withAction: {
            if NSApp.isActive {
                NSApplication.shared().windows.last?.close()
            } else {
                NSApp.activate(ignoringOtherApps: true)
            }
        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

