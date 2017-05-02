//
//  ViewController.swift
//  Cards
//
//  Created by Michael Buss Andersen on 15/03/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

//protocol ViewControllerDelegate: class {
//    func textFieldContains(viewController: ViewController)
//}

class ViewController: NSViewController, NSTextStorageDelegate {
    @IBOutlet var textViewOutlet: NSTextView!
    let document = Document()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        textViewOutlet.textContainerInset = NSSize(width: 5, height: 5)
        textViewOutlet.string = document.content
        textViewOutlet.textStorage?.delegate = self
        textViewOutlet.isContinuousSpellCheckingEnabled = false
        textViewOutlet.font = NSFont(name: "Monaco", size: 15.0)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        //var range = textViewOutlet.selectedRange()
        //range.location -= 1
        
        let r = SmartReplacer(ats: textStorage, sel: textViewOutlet)
        let posDelta = r.replace()
        
        
        
        
        //for _ in 0...(posDelta) { textViewOutlet.moveLeft(nil) }
        
        //var range = textViewOutlet.selectedRange()
        //range.location -= posDelta
        
        
        //textStorage.setAttributedString(r.ats.copy() as! NSAttributedString)
        //textViewOutlet.setSelectedRange(range)
        
        
        let h = Highlighter(str: textStorage.string, ats: textStorage)
        let _ = h.getHighlightedString()
        
        textStorage.append(NSAttributedString(string: String(repeating: " ", count: posDelta)))
    }

    func insertSnippet(snippet: String){
        textViewOutlet.insertText(snippet, replacementRange: NSMakeRange(4, 0))
    }
    

}

