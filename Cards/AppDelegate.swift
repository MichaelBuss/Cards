//
//  AppDelegate.swift
//  Cards
//
//  Created by Michael Buss Andersen on 15/03/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if (UserDefaults.standard.string(forKey: "rotationdeg") == nil) {
            UserDefaults.standard.set("100", forKey: "rotationdeg")
        }
        if (UserDefaults.standard.string(forKey: "rotationmm") == nil) {
            UserDefaults.standard.set("100", forKey: "rotationmm")
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

