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
    @IBOutlet var helpTextOutlet: NSTextView!
    
    let helpText = "Du kan få robotten til at bevæge sig, tale og reagere på sensorer ved at skrive kommandoer i tekstfeltet. Kommandoerne kan være svære at huske, så for at komme i gang, kan du prøve at trykke på + knappen og indsætte nogle simple kommandoer. Du kan derefter ændre i dem for at tilpasse til dit behov.\n\nHer er nogle flere idéer til hvad du kan skrive:\n\n"
   
    let helpExampleForward = "For at få robotten til at køre frem:\nFrem: 5 cm\nFrem: 2 sekunder\nFrem: 1 rotation\nFrem: 180 grader\nFrem: til kontakt\n\n"
    let helpExampleBackward = "For at få robotten til at køre tilbage:\nTilbage: 5 cm\nTilbage: 2 sekunder\nTilbage: 1 rotation\nTilbage: 180 grader\nTilbage: til kontakt\n\n"
    let helpExampleTurn = "For at få robotten til at køre dreje:\nDrej højre: 90 grader\nDrej venstre: 2 sekunder\nDrej højre: farve == sort\n\n"
    
    
    let addText = NSAttributedString(string:"Hello")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        helpTitleOutlet.stringValue = "Velkommen til Cards!"
        helpTextOutlet.string = helpText+helpExampleForward+helpExampleBackward+helpExampleTurn
    }
    
}
