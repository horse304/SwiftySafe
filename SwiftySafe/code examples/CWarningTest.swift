//
//  CWarningTest.swift
//  CXcodePluginDemo
//
//  Created by Christoph Reinders on 26/04/15.
//  Copyright (c) 2015 Christoph Reinders. All rights reserved.
//

import Cocoa

class CWarningTest: NSObject {
    //Coming some really! bad code
    
    func test3() {
        var x: Int?
        
        if x!.hashValue == 8 {
            x = x!+1
            x = x!
        }
        
    }
    
    func test2() {
        var force = true
        if !force {
        }
    }
    
    func test() {
        
        var x: String?
        
        var y = x!;
        
        println("test!!!")
    }
    
    
}
