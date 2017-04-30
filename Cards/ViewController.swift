//
//  ViewController.swift
//  Cards
//
//  Created by Michael Buss Andersen on 15/03/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextStorageDelegate, NSTextViewDelegate {
    @IBOutlet var textViewOutlet: NSTextView!
    let document = Document()

    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        textViewOutlet.textContainerInset = NSSize(width: 5, height: 5)
        textViewOutlet.string = document.content
        textViewOutlet.textStorage?.delegate = self

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        let h = Highlighter(str: textStorage.string, ats: textStorage)
        let _ = h.getHighlightedString()
    }

    func insertSnippet(snippet: String){
        textViewOutlet.insertText(snippet, replacementRange: NSMakeRange(4, 0))
    }

}

