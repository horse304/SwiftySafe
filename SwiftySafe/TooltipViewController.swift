//
//  TooltipViewController.swift
//  CXcodePluginDemo
//
//  Created by Christoph Reinders on 28/04/15.
//  Copyright (c) 2015 Christoph Reinders. All rights reserved.
//

import Cocoa

class TooltipViewController: NSViewController {
    var warning: SWarning?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func pressReplace(sender: AnyObject) {
        if let w = warning {
            SUtility.sharedInstance.autocorrect(w)
        }
    }
    
}
