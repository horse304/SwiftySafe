//
//  CWarningTest2.swift
//  CXcodePluginDemo
//
//  Created by Christoph Reinders on 26/04/15.
//  Copyright (c) 2015 Christoph Reinders. All rights reserved.
//

import Cocoa

class CWarningTest2: NSObject {
    //here as well!
    
    
    func test() {
        var x: Int?
        
        
        var y = x!
        var z = x!
        
        
        /*

        Will we also find this?! 
        */
    }
    
    
    
    func test5() {
        var a: String?
        
        if a!.toInt()!.hashValue == 6 {
            a = a!+"g"
        }
    }
    
    func test6() {
        var a: String?
        
        var b = String(stringLiteral:a!)
        
        
    }
}
