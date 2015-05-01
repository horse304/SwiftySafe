//
//  SUtility.swift
//  CXcodePluginDemo
//
//  Created by Christoph Reinders on 26/04/15.
//  Copyright (c) 2015 Christoph Reinders. All rights reserved.
//

import Cocoa
import AppKit

class SUtility: NSObject {
    static let sharedInstance = SUtility()
    
//    var tooltipViewController: TooltipViewController?
    
    class func currentEditor() -> AnyObject? {
        if let workspaceController = SUtility.currentWorkspaceController() {
            var editorArea = workspaceController.editorArea()
            var editorContent = editorArea.lastActiveEditorContext()
            return editorContent.editor()
        }
        return nil
    }
    
    class func currentWorkspaceController() -> IDEWorkspaceWindowController? {
        if let wd = NSApp.mainWindow {
            if let currentWindowController  = wd?.windowController() as? IDEWorkspaceWindowController {
                return currentWindowController
            }
        }
        return nil
    }
    
    class func currentWorkspaceDocument() -> IDEWorkspaceDocument? {
        if let wd = NSApp.mainWindow {
            if let currentWindowController  = wd?.windowController() as? NSWindowController {
                if let document = currentWindowController.document as? IDEWorkspaceDocument {
                    return document
                }
            }
        }
        return nil
    }
    class func findFiles(projectDirectory: String, fileExtensions: [String]) -> [SFile]{
        var allFiles = [SFile]()
        
        var fileManager = NSFileManager.defaultManager()
        
        var error: NSError?
        var directories = [""]
        while (directories.count > 0) {
            var relDir = directories.removeLast()
            var absDir = projectDirectory.stringByAppendingPathComponent(relDir)
            
            if let files = fileManager.contentsOfDirectoryAtPath(absDir, error: &error) as? [String] {
                for file in files {
                    var path = absDir.stringByAppendingPathComponent(file)
                    var isDir : ObjCBool = false
                    if fileManager.fileExistsAtPath(path, isDirectory: &isDir) {
                        var relFileDir = relDir.stringByAppendingPathComponent(file)
                        
                        if isDir {
                            directories.append(relFileDir)
                        } else {
                            if contains(fileExtensions, file.pathExtension) {
                                var sfile = SFile(projectDir: projectDirectory, relPath: relFileDir)
                                
                                allFiles.append(sfile)
                            }
                            
                        }
                    }
                }
                
            }
        }
        
        return allFiles
    }
    
    
    class func findWarnings(projectDirectory: String) -> [SFile] {
        var warningsFiles = [SFile]()
        
        var files = SUtility.findFiles(projectDirectory, fileExtensions:["swift"])
        
        for file in files {
            if file.hasWarning() {
                warningsFiles.append(file)
            }
        }
        
        return warningsFiles
    }
    
    func highlightWarning(warning: SWarning, textView: NSTextView) {
        if let text = textView.string {
            
            if let position = text.rangeOfString(warning.lineContent) {
                let start = distance(text.startIndex, position.startIndex)
                let length = distance(position.startIndex, position.endIndex)
                let range = NSMakeRange(start, length)
                
                textView.scrollRangeToVisible(range)
                textView.setSelectedRange(range)
                
                
                
                
//                var activeRange = textView.layoutManager?.glyphRangeForCharacterRange(range, actualCharacterRange: nil)
//                var neededRect = textView.layoutManager?.boundingRectForGlyphRange(activeRange!, inTextContainer: textView.textContainer!)
//                var containerOrigin = textView.textContainerOrigin
//                
//                neededRect?.origin.x += containerOrigin.x
//                neededRect?.origin.y += containerOrigin.y
//                
//                neededRect = textView.convertRectToLayer(neededRect!)
//                var bundle = NSBundle(forClass:object_getClass(self))
//                
//                if let viewController = TooltipViewController(nibName: "TooltipViewController", bundle:bundle) {
//                    tooltipViewController = viewController
//                    viewController.warning = warning
//                    viewController.view.frame = NSMakeRect(neededRect!.origin.x, neededRect!.origin.y, 100, 100)
//                    
//                    textView.addSubview(viewController.view)
//                }
            }
        }
    }
    
    func autocorrect(warning: SWarning) {
        if let editor: AnyObject = SUtility.currentEditor() {
            if editor.respondsToSelector("textView") {
                if let textView = editor.textView {
                    if let text = textView?.string {
                        var textModified = SFile.cleanString(text)
                        
                        
                        
                        
                        
                        if let position = text.rangeOfString(warning.lineContent) {
                            if let excPosition = text.rangeOfString("!", range: position) {
                                var dist = distance(text.startIndex, excPosition.startIndex)
                                var modPosition = advance(textModified.startIndex, dist)
                                
                                var characterOrigin  = text[excPosition]
                                var characterMod = textModified[modPosition]
                                
                                
                                println(excPosition)
                                advance(position.startIndex, 4)
                            }
                            

                        }
                        
                        
                        
                    }
                }
            }
        }
    }
    
    func openWarning(warning: SWarning) {
        
        if let currentWindowController = SUtility.currentWorkspaceController() {
            if let appDelegate = NSApplication.sharedApplication().delegate {
                if appDelegate.application!(NSApplication.sharedApplication(), openFile: warning.absolutePath()) {
                    if let editor: AnyObject = SUtility.currentEditor() {
                        if editor.respondsToSelector("textView") {
                            if let textView = editor.textView {
                                self.highlightWarning(warning, textView: textView!)
                                
                            }
                        }
                    }

                }
                
                
            }

        }

    }
}
