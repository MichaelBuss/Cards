//
//  WindowController.swift
//  Cards
//
//  Created by Michael Buss Andersen on 18/03/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
//    Outlets
    @IBOutlet weak var runOutlet: NSButton!
    @IBOutlet weak var statusOutlet: NSToolbarItem!
    @IBOutlet weak var statusTextOutlet: NSTextFieldCell!
    @IBOutlet weak var statusTextFieldOutlet: NSTextField!
    
//    Variables
    
//    Instances
    let windowModel = WindowModel()
    

    override func windowDidLoad() {
        super.windowDidLoad()
        statusTextFieldOutlet.isSelectable = false
        statusTextFieldOutlet.stringValue = "Connect to Robot 🤖 via Bluetooth ⚠️"

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBAction func runAction(_ sender: Any) {
        //When the run button is pressed
//        runOutlet.isEnabled = false //Disable button while code is running
        runOutlet.image = #imageLiteral(resourceName: "Stop")
        windowModel.runPython()
        
        
//        runOutlet.isEnabled = true //Enable button again
        runOutlet.image = #imageLiteral(resourceName: "Run")
    }
    
    func runButtonIsEnabled(enable: Bool) {
        runOutlet.isEnabled = enable
    }



}
