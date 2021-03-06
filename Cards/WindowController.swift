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
        
        let viewCtrl: ViewController = self.contentViewController as! ViewController
        
        let nc = NotificationCenter.default
        nc.addObserver(forName: Notification.Name.NSTextViewDidChangeSelection, object: viewCtrl.textViewOutlet, queue: nil) { (notification) in
            let textView = notification.object as! NSTextView
            if textView.selectedRange().length > 0 {
                self.runOutlet.image = #imageLiteral(resourceName: "Run Selection")
            } else {
                self.runOutlet.image = #imageLiteral(resourceName: "Run")
            }
        }
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBAction func runAction(_ sender: Any) {
        //When the run button is pressed
//        runOutlet.isEnabled = false //Disable button while code is running
        
        let viewCtrl: ViewController = self.contentViewController as! ViewController
        
        runOutlet.image = #imageLiteral(resourceName: "Stop")
        statusTextFieldOutlet.stringValue = "Overfører...⏳"
        var textToRun = ""
        
        if viewCtrl.textViewOutlet.selectedRange().length == 0 {
            textToRun = viewCtrl.textViewOutlet.string!
        } else {
            let range = viewCtrl.textViewOutlet.selectedRange()
            textToRun = ((viewCtrl.textViewOutlet.string as NSString?)?.substring(with: range))!
        }
        
        windowModel.runPython(code: textToRun, compiled: {
            self.statusTextOutlet.stringValue = "Robotten kører 🤖"
        }, finished: {
            self.statusTextOutlet.stringValue = "Færdig 🙌"
            self.runOutlet.image = #imageLiteral(resourceName: "Run")
            self.resetStatusTextAfter(seconds: 6)
        }, failed: {
            self.statusTextOutlet.stringValue = "Fejl"
            self.runOutlet.image = #imageLiteral(resourceName: "Run")
            self.resetStatusTextAfter(seconds: 6)
        })
        
//        runOutlet.isEnabled = true //Enable button again
        
    }
    
    func resetStatusTextAfter(seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.statusTextOutlet.stringValue = "Skriv noget kode 👩‍💻👨‍💻"
        }
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
            
            if characterBeforeCursor(textView: viewCtrl.textViewOutlet) == "\n" {
                text = text?.insert(string: "\(snippet.standard)", ind: pos)
            } else {
                text = text?.insert(string: "\n\(snippet.standard)", ind: pos)
            }
            
        } else {
            text?.append("\n\(snippet.standard)")
        }
        
        viewCtrl.textViewOutlet.string = text
        
        print()
        
    }
    
    private func characterBeforeCursor(textView: NSTextView) -> String? {
        
        let selectedRanges = textView.selectedRanges
        let text = textView.string
    
        return (text! as NSString).substring(with: NSRange(location: selectedRanges.first!.rangeValue.location-1, length: 1))
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
