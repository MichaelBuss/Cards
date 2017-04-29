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
}

class SnippetViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    weak var delegate: SnippetViewControllerDelegate?
    
    @IBOutlet weak var snippetTableViewOutlet: NSTableView!
    var snippets = [
        Snippet(title: "Frem", content: #imageLiteral(resourceName: "Snippets_Arrow Forward")),
        Snippet(title: "Tilbage", content: #imageLiteral(resourceName: "Snippets_Arrow Backward")),
        Snippet(title: "Drej", content: #imageLiteral(resourceName: "Snippets_Arrow Turn Sharp")),
        Snippet(title: "Brems", content: #imageLiteral(resourceName: "Snippets_Break")),
        Snippet(title: "Enkelt Stor Motor", content: #imageLiteral(resourceName: "Snippets_Motor Large")),
        Snippet(title: "Enkelt Mellem Motor", content: #imageLiteral(resourceName: "Snippets_Motor Small")),
        Snippet(title: "Højtaler", content: #imageLiteral(resourceName: "Snippets_Speaker")),
        Snippet(title: "Ny funktion", content: #imageLiteral(resourceName: "Snippets_Function New")),
        Snippet(title: "Brug funktion", content: #imageLiteral(resourceName: "Snippets_Function Use")),
        Snippet(title: "Gentag", content: #imageLiteral(resourceName: "Snippets_Loop")),
        Snippet(title: "Gør hvis", content: #imageLiteral(resourceName: "Snippets_Do If")),
        Snippet(title: "Husk", content: #imageLiteral(resourceName: "Snippets_Remember"))
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
