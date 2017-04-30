//
//  HelpViewController.swift
//  Cards
//
//  Created by Michael Buss Andersen on 25/04/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

class HelpViewController: NSViewController {

    @IBOutlet weak var helpTitleOutlet: NSTextField!
    @IBOutlet weak var helpTextOutlet: NSTextField!
    
    let helpText = "Hey"
    let attribute = [NSForegroundColorAttributeName: NSColor.blue]
    let helpTextAttributed = NSAttributedString(string: "hey", attributes: [NSForegroundColorAttributeName: NSColor.blue])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        helpTitleOutlet.stringValue = "Velkommen til Cards!"
        helpTextOutlet.attributedStringValue = helpTextAttributed
    }
    
}
