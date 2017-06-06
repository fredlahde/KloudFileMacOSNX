//
//  AppDelegate.swift
//  KloudFileMacOSNX
//
//  Created by Frederick Lahde on 19/10/2016.
//  Copyright © 2016 Kloudfile. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let screenshotManager = ScreenshotManager()

    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)


    @IBAction func screenshotClicked(_ sender: AnyObject) {
        screenshotManager.takeScreenshot()
    }

    @IBAction func quitClicked(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu

        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

