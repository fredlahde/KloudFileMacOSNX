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
    
    
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    
    
    @IBAction func screenshotClicked(_ sender: AnyObject) {
        let task = Process()
        
        task.launchPath = "/usr/sbin/screencapture"
        task.arguments = ["-i", "screen.png"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

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

