//
//  Document.swift
//  Cards
//
//  Created by Michael Buss Andersen on 15/03/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    var content:String = "" //Davs. String to be inseerted when starting from blank

    
    
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
        if let vc = windowController.contentViewController as? ViewController {
            vc.textViewOutlet.string = content
        }
        self.addWindowController(windowController)
    }
    
    override func read(from url: URL, ofType typeName: String) throws {
        content = try String(contentsOf: url, encoding: String.Encoding.utf8)
    }
    
    override func data(ofType typeName: String) throws -> Data {
        if let vc = self.windowControllers[0].contentViewController as? ViewController {
            return vc.textViewOutlet.string?.data(using: String.Encoding.utf8) ?? Data()
        } else {
            return Data()
        }
    }
    
    func write(save text: String) throws {
        try text.write(to: fileURL!, atomically: true, encoding: String.Encoding.utf8)
    }
    

}
