//
//  SwiftySafe.swift
//
//  Created by Christoph Reinders on 01/05/15.
//  Copyright (c) 2015 Christoph Reinders. All rights reserved.
//

import AppKit

var sharedPlugin: SwiftySafe?

class SwiftySafe: NSObject {
    var bundle: NSBundle
    var windowController: SPluginWindowController?
    
//    override class func pluginDidLoad(bundle: NSBundle) {
//        let appName = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? NSString
//        if appName == "Xcode" {
//            sharedPlugin = SwiftySafe(bundle: bundle)
//        }
//    }

    init(bundle: NSBundle) {
        self.bundle = bundle

        super.init()
        createMenuItems()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func createMenuItems() {
        if let menuItem = NSApp.mainMenu??.itemWithTitle("Edit") {
            if let submenu = menuItem.submenu {
                var actionMenuItem = NSMenuItem(title:"Perform SwiftySafe Check", action:"performCheck", keyEquivalent:"")
                //TODO: add shortcut
                actionMenuItem.target = self
                submenu.addItem(NSMenuItem.separatorItem())
                submenu.addItem(actionMenuItem)
            } else {
                println("could not get submenu")
            }
        } else {
            println("did not find menu")
        }
    }

    func performCheck() {
        if self.windowController == nil {
            var wc = SPluginWindowController(windowNibName: "SPluginWindowController")
            self.windowController = wc
        }
        
        var filePath = SUtility.currentWorkspaceDocument()?.workspace.representingFilePath.fileURL.path
        var projectDir = filePath?.stringByDeletingLastPathComponent
        var projectName = filePath?.lastPathComponent
        
        self.windowController?.projectName = projectName;
        self.windowController?.projectDir = projectDir;
        self.windowController?.refresh()
        self.windowController?.window?.makeKeyAndOrderFront(nil)
    }
    
    override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
        return SUtility.currentWorkspaceDocument()?.workspace != nil
    }

}

