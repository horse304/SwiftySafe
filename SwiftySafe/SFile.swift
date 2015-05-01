//
//  SFile.swift
//  CXcodePluginDemo
//
//  Created by Christoph Reinders on 26/04/15.
//  Copyright (c) 2015 Christoph Reinders. All rights reserved.
//

import Cocoa

class SFile: NSObject {
    var projectDir: String
    var relPath: String
    var warnings = [SWarning]()
    
    init(projectDir pd: String, relPath rp: String) {
        
        projectDir = pd
        relPath = rp
        
        super.init()

        self.read()
    }
    
    func read() {
        var error: NSError?

        var path = projectDir.stringByAppendingPathComponent(relPath)
        if let content = NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: &error) as? String {
            var modifiedContent = SFile.cleanString(content)
            
            var linesModified = modifiedContent.componentsSeparatedByString("\n")

            var lines = content.componentsSeparatedByString("\n")
            
            var location: Int = 0
            for var i = 0; i < lines.count;i++ {
                var line = lines[i]
                var lineModified = linesModified[i]
                
                
                if lineModified.rangeOfString("!") != nil {
                    if lineModified.rangeOfString("@IBOutlet") != nil {
                        continue
                    }
                    
                    
                    var warning = SWarning(projectDir: projectDir, relPath: relPath, line: i+1, location: location, lineContent: line)
                    warnings.append(warning)
                }
                
                location += count(line)+1
            }
        }
    }
    
    
    
    func hasWarning() -> Bool {
        return warnings.count > 0
    }
    
    override var description : String {
        return "\(relPath): \(warnings.count) warnings\n"
    }
    
    
    class func cleanString(content: String) -> String {
        var modifiedContent = content
        //remove \"
        modifiedContent = modifiedContent.stringByReplacingOccurrencesOfString("\\\"", withString: "XX", options: nil, range: Range(start: modifiedContent.startIndex, end: modifiedContent.endIndex))
        
        //remove !=
        modifiedContent = modifiedContent.stringByReplacingOccurrencesOfString("!=", withString: "XX", options: nil, range: Range(start: modifiedContent.startIndex, end: modifiedContent.endIndex))
        
        //remove " !"
        modifiedContent = modifiedContent.stringByReplacingOccurrencesOfString(" !", withString: "XX", options: nil, range: Range(start: modifiedContent.startIndex, end: modifiedContent.endIndex))
        
        //remove all strings
        var error:NSError?
        var regexQuotes = NSRegularExpression(pattern: "(\".*?\")", options: .DotMatchesLineSeparators, error: &error)
        
        if let matches = regexQuotes?.matchesInString(modifiedContent, options: nil, range: NSMakeRange(0, count(modifiedContent))) as? [NSTextCheckingResult] {
            
            for var i  = matches.count-1; i >= 0;i-- {
                var match = matches[i]
                var substr = (modifiedContent as NSString).substringWithRange(match.range)
                
                var str = ""
                
                for character in substr {
                    if character == "\n" {
                        str += "\n"
                    } else {
                        str += "X"
                    }
                }
                
                modifiedContent = (modifiedContent as NSString).stringByReplacingCharactersInRange(match.range, withString: str)
            }
        }
        
        //remove comments like /* */
        var regexComment = NSRegularExpression(pattern: "(\\/\\*.*\\*\\/)", options: .DotMatchesLineSeparators, error: &error)
        
        if let matches = regexComment?.matchesInString(modifiedContent, options: nil, range: NSMakeRange(0, count(modifiedContent))) as? [NSTextCheckingResult] {
            
            for var i  = matches.count-1; i >= 0;i-- {
                var match = matches[i]
                var substr = (modifiedContent as NSString).substringWithRange(match.range)
                
                var str = ""
                
                for character in substr {
                    if character == "\n" {
                        str += "\n"
                    } else {
                        str += "X"
                    }
                }
                
                modifiedContent = (modifiedContent as NSString).stringByReplacingCharactersInRange(match.range, withString: str)
            }
        }
        
        //remove comments like //
        var regexCommentSmall = NSRegularExpression(pattern: "(\\/\\/.*)", options: nil, error: &error)
        
        if let matches = regexCommentSmall?.matchesInString(modifiedContent, options: nil, range: NSMakeRange(0, count(modifiedContent))) as? [NSTextCheckingResult] {
            
            for var i  = matches.count-1; i >= 0;i-- {
                var match = matches[i]
                var substr = (modifiedContent as NSString).substringWithRange(match.range)
                
                var str = ""
                
                for character in substr {
                    if character == "\n" {
                        str += "\n"
                    } else {
                        str += "X"
                    }
                }
                
                modifiedContent = (modifiedContent as NSString).stringByReplacingCharactersInRange(match.range, withString: str)
            }
        }
        
        return modifiedContent
    }
}
