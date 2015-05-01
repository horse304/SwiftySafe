//
//  SWarning.swift
//  CXcodePluginDemo
//
//  Created by Christoph Reinders on 26/04/15.
//  Copyright (c) 2015 Christoph Reinders. All rights reserved.
//

import Foundation

class SWarning: NSObject {
    var projectDir: String
    var relPath: String
    var line: Int
    var lineContent: String
    var location: Int

    init(projectDir pd: String, relPath rp: String, line l: Int, location loc: Int, lineContent lc: String) {
        projectDir = pd
        relPath = rp
        line = l
        location = loc
        lineContent = lc
    }
    
    func lineContentPrintable() -> String {
        return lineContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    func absolutePath() -> String {
        return projectDir.stringByAppendingPathComponent(relPath)
    }
    
    override var description : String {
        return "\(relPath) line \(line)\n"
    }
}