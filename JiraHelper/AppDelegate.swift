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

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        let shortcut = MASShortcut(keyCode: UInt(kVK_F9), modifierFlags: NSEventModifierFlags.command.rawValue)
        MASShortcutMonitor.shared().register(shortcut, withAction: {
            NSApp.activate(ignoringOtherApps: true)
        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

