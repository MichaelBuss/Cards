//
//  Document.swift
//  Cards
//
//  Created by Michael Buss Andersen on 15/03/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    var content:String = "Davs"

    
    
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
    
    override func read(from url: URL, ofType typeName: String) throws {
        content = try String(contentsOf: url, encoding: String.Encoding.utf8)
    }
    
    func write(save text: String) throws {
        //try content.write(to: url, atomically: true, encoding: String.Encoding.utf8)
        try text.write(to: fileURL!, atomically: true, encoding: String.Encoding.utf8)
        
    }
    

}
