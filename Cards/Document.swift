//
//  Document.swift
//  Cards
//
//  Created by Michael Buss Andersen on 15/03/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

class Document: NSPersistentDocument {

    var content:String = ""
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
    }
    
    override func read(from: URL, ofType typeName: String) throws {
        content = String(describing: URL.self)
    }

}
