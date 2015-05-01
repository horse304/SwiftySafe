//
//  SPluginWindowController.swift
//  SwiftySafe
//
//  Created by Christoph Reinders on 01/05/15.
//  Copyright (c) 2015 Christoph Reinders. All rights reserved.
//

import Cocoa

class SPluginWindowController: NSWindowController {

    var projectName: String?
    var projectDir: String?
    var files: [SFile]?
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        var x = SUtility.currentWorkspaceDocument()
        outlineView?.reloadData()
        outlineView?.expandItem(nil, expandChildren: true)
    }
    
    func refresh() {
        files = SUtility.findWarnings(self.projectDir!)
        
        outlineView?.reloadData()
        outlineView?.expandItem(nil, expandChildren: true)
    }
    
    @IBAction func pressedRefresh(sender: AnyObject) {
        refresh()
    }
    
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if item == nil {
            if let cou = files?.count {
                return cou
            }
        } else if let file = item as? SFile {
            return file.warnings.count
        }
        
        return 0
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if item == nil {
            if let f = files?[index] {
                return f
            }
        } else if let file = item as? SFile {
            return file.warnings[index]
        }
        
        return ""
        
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        if let file = item as? SFile {
            return true
        }
        return false
    }
    
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        if let file = item as? SFile {
            var cell = outlineView.makeViewWithIdentifier("HeaderCell", owner: self) as? NSTableCellView
            cell?.textField?.stringValue = file.relPath
            return cell
        } else if let warning = item as? SWarning {
            var cell = outlineView.makeViewWithIdentifier("WarningCell", owner: self) as? NSTableCellView
            
            cell?.textField?.stringValue = String(warning.lineContentPrintable())
            return cell
        }
        
        return nil
    }
    
    func outlineViewSelectionDidChange(notification: NSNotification) {
        if let coutlineView = notification.object as? NSOutlineView {
            var row = coutlineView.selectedRow
            if let warning = coutlineView.itemAtRow(row) as? SWarning {
                SUtility.sharedInstance.openWarning(warning)
            } else {
                coutlineView.deselectRow(row)
            }
            
        }
    }

    
}
