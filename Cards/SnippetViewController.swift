//
//  SnippetViewController.swift
//  Cards
//
//  Created by Michael Buss Andersen on 19/04/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

protocol SnippetViewControllerDelegate: class {
    func didChoseSnippet(snippet: Snippet)
}

struct Snippet {
    var title: String
    var content: NSImage
    var standard: String
}

class SnippetViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    weak var delegate: SnippetViewControllerDelegate?
    
    @IBOutlet weak var snippetTableViewOutlet: NSTableView!
    var snippets = [
        Snippet(title: "Frem", content: #imageLiteral(resourceName: "Snippets_Arrow Forward"), standard: "Frem: 5 cm"),
        Snippet(title: "Tilbage", content: #imageLiteral(resourceName: "Snippets_Arrow Backward"), standard: "Tilbage: 5 cm"),
        Snippet(title: "Drej", content: #imageLiteral(resourceName: "Snippets_Arrow Turn Sharp"), standard: "Drej: 90 grader højre"),
        Snippet(title: "Brems", content: #imageLiteral(resourceName: "Snippets_Break"), standard: "Brems"),
        Snippet(title: "Enkelt Stor Motor", content: #imageLiteral(resourceName: "Snippets_Motor Large"), standard: "Motor D: 1 rotation frem"),
        Snippet(title: "Enkelt Mellem Motor", content: #imageLiteral(resourceName: "Snippets_Motor Small"), standard: "Motor A: 1 rotation frem"),
        Snippet(title: "Højtaler", content: #imageLiteral(resourceName: "Snippets_Speaker"), standard: "Højtaler: LEGO"),
        Snippet(title: "Ny funktion", content: #imageLiteral(resourceName: "Snippets_Function New"), standard: "Ny Funktion: MitFunktionsNavn (\n\t//Skriv kode her mellem parenteserne så det kan bruges senere\n\t\n)"),
        Snippet(title: "Brug funktion", content: #imageLiteral(resourceName: "Snippets_Function Use"), standard: "Funktion: MitFunktionsNavn"),
        Snippet(title: "Gentag", content: #imageLiteral(resourceName: "Snippets_Loop"), standard: "Gentag: 2 gange (\n\t//Skriv kode her mellem parenteserne for at gentage det\n\t\n)"),
        Snippet(title: "Gør hvis", content: #imageLiteral(resourceName: "Snippets_Do If"), standard: "Hvis: Farve == blå eller Farve == grøn (\n\t//Skriv hvad der skal ske her, mellem parenteserne\n\t\n)\nEllers hvis: Farve == rød (\n\t//Skriv hvad der skal ske her, mellem parenteserne\n\t\n)\n"),
        Snippet(title: "Husk", content: #imageLiteral(resourceName: "Snippets_Remember"), standard: "Husk: MitHuskeNavn = Seneste kørsel cm"),
        Snippet(title: "Kommentar", content: #imageLiteral(resourceName: "Comment"), standard: "// Jeg er en kommentar ")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        snippetTableViewOutlet.reloadData()
        snippetTableViewOutlet.delegate = self
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return snippets.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.make(withIdentifier: "cell", owner: nil) as? SnippetCell {
            cell.cellSetup(image: snippets[row].content, title: snippets[row].title)
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        delegate?.didChoseSnippet(snippet: snippets[row])
        return true
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        self.snippetTableViewOutlet.deselectRow(self.snippetTableViewOutlet.selectedRow)
    }
    
}
