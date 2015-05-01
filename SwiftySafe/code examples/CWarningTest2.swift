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

        Will we also find this one?! hahaha
        */
    }
    
    func test3() {
        var x: Int?
        
        if x!.hashValue == 8 {
            //move this
            x = x!+1
            x = x!
        }
        
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
