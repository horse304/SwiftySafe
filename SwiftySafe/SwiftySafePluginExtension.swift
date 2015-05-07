//
//  SwiftySafePluginExtension.swift
//  SwiftySafe
//
//  Created by Christoph Reinders on 07/05/15.
//  Copyright (c) 2015 Christoph Reinders. All rights reserved.
//

import Foundation

extension NSObject {
    class func pluginDidLoad(bundle: NSBundle) {
        let appName = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? NSString
        if appName == "Xcode" {
            if sharedPlugin == nil {
                sharedPlugin = SwiftySafe(bundle: bundle)
            }
        }
    }
}