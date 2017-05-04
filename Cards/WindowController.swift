//
//  WindowController.swift
//  Cards
//
//  Created by Michael Buss Andersen on 18/03/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

protocol WindowControllerDelegate: class {
    func textViewChanged(windowController: WindowController)
}

class WindowController: NSWindowController, SnippetViewControllerDelegate {
//    Outlets
    @IBOutlet weak var runOutlet: NSButton!
    @IBOutlet weak var statusOutlet: NSToolbarItem!
    @IBOutlet weak var statusTextOutlet: NSTextFieldCell!
    @IBOutlet weak var statusTextFieldOutlet: NSTextField!
    
    weak var delegate: WindowControllerDelegate?
    
//    Variables
    
//    Instances
    let windowModel = WindowModel()
    

    override func windowDidLoad() {
        super.windowDidLoad()
        statusTextFieldOutlet.isSelectable = false
        statusTextFieldOutlet.stringValue = "Skriv noget kode 👩‍💻👨‍💻"
        
        
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBAction func runAction(_ sender: Any) {
        //When the run button is pressed
//        runOutlet.isEnabled = false //Disable button while code is running
        
        let viewCtrl: ViewController = self.contentViewController as! ViewController
        
        runOutlet.image = #imageLiteral(resourceName: "Stop")
        statusTextFieldOutlet.stringValue = "Overfører...⏳"
        windowModel.runPython(code: viewCtrl.textViewOutlet.string!, compiled: {
            self.statusTextOutlet.stringValue = "Robotten kører 🤖"
        }, finished: {
            self.statusTextOutlet.stringValue = "Færdig 🙌"
            self.runOutlet.image = #imageLiteral(resourceName: "Run")
        }, failed: {
            self.statusTextOutlet.stringValue = "Fejl"
            self.runOutlet.image = #imageLiteral(resourceName: "Run")
        })
        
        
//        runOutlet.isEnabled = true //Enable button again
        
    }
    
    func runButtonIsEnabled(enable: Bool) {
        runOutlet.isEnabled = enable
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "snippet" {
            if let vc = segue.destinationController as? SnippetViewController {
                vc.delegate = self
            }
        }
    }
    
    func didChoseSnippet(snippet: Snippet) {
        let viewCtrl: ViewController = self.contentViewController as! ViewController
        var text = viewCtrl.textViewOutlet.string
        
        if let position = viewCtrl.textViewOutlet.selectedRanges.first?.rangeValue.location {
            let pos = nextLineBreak(text: text!, position: position)
            
            text = text?.insert(string: "\n\(snippet.standard)", ind: pos)
        } else {
            text?.append("\n\(snippet.standard)")
        }
        
        viewCtrl.textViewOutlet.string = text
        
        print()
        
    }
    
    func nextLineBreak(text: String, position: Int) -> Int {
        if text.characters.count == 0 {
            return 0
        }
        if text.characters.count == position {
            return position
        }
        let char = text[text.index(text.startIndex, offsetBy: position)]
        if (char != "\n") {
            return nextLineBreak(text: text, position: position+1)
        } else {
            return position
        }
    }


}

extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
}
