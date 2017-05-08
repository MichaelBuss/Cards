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
    let helpExampleTurn = "For at få robotten til at dreje:\nDrej: 90 grader højre\nDrej: 2 sekunder venstre\n\n"
    let helpExampleFunction = "For at kunne genbruge kode laves en funktion:\nNy Funktion: FunktionsNavn (\n\t//Skriv kode her mellem parenteserne og brug det senere\n\n)\nEn funktion kan bruges igen og igen ved at skrive Funktion: funktionsNavn.\n\n"
    let helpExampleLoop = "For at gøre det samme mange gange i træk:\nGentag: 2 gange (\n\t//Skriv kode her mellem parenteserne og det gentages\n\t\n)\n\n"
    let helpExampleIf = "Hvis man vil have noget til at ske på en eller flere betingelser:\nHvis: Farve == blå eller Farve == grøn (\n//Skriv hvad der skal ske her, mellem parenteserne\n\n)\nEllers hvis: Farve==rød (\n//Skriv hvad der skal ske her, mellem parenteserne\n\n)\nMan kan lave så mange Ellers Hvis eller Ellers, som man har brug for.\n\n"
    let helpExampleVar = "For at huske en værdi til senere:\nHusk: variabelnavn = Samlet kørsel cm\nHusk: variabelnavn = Seneste kørsel cm\nHusk: variabelnavn = Samlet Motor A omdrejninger\nHusk: variabelnavn = Farve\n\n"
    
    
    let addText = NSAttributedString(string:"Hello")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        helpTitleOutlet.stringValue = "Velkommen til Cards!"
        helpTextOutlet.string = helpText+helpExampleForward+helpExampleBackward+helpExampleTurn+helpExampleFunction+helpExampleLoop+helpExampleIf+helpExampleVar
    }
    
}
