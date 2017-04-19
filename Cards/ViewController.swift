//
//  ViewController.swift
//  Cards
//
//  Created by Michael Buss Andersen on 15/03/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var textViewOutlet: NSTextView!
    let document = Document()

    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        textViewOutlet.textContainerInset = NSSize(width: 5, height: 5)
        textViewOutlet.string = document.content
        
        
        

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

