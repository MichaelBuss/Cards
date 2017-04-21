//
//  SnippetViewController.swift
//  Cards
//
//  Created by Michael Buss Andersen on 19/04/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

class SnippetViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var snippetTableViewOutlet: NSTableView!
        
    var cellText = ["Frem","Tilbage","Drej", "Enkelt Motor", "Gentag", "Gør hvis"]
    var cellImages = [
        #imageLiteral(resourceName: "Snippets_Arrow Forward"),
        #imageLiteral(resourceName: "Snippets_Arrow Backward"),
        #imageLiteral(resourceName: "Snippets_Arrow Turn Sharp"),
        #imageLiteral(resourceName: "Snippets_Motor"),
        #imageLiteral(resourceName: "Snippets_Loop"),
        #imageLiteral(resourceName: "Snippets_Do If")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        snippetTableViewOutlet.reloadData()
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return cellText.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.make(withIdentifier: "cell", owner: nil) as? SnippetCell {
            if cellText.count == cellImages.count{ // Checks for equal amounts of images and texts
                cell.cellSetup(image: cellImages[row], title: cellText[row])
            } else {
                cell.cellSetup(image: #imageLiteral(resourceName: "Snippets_Missing"), title: "Missing description")
            }
            return cell
        }
        return nil
    }
    
    func  tableViewSelectionDidChange(_ notification: Notification) {
        if (self.snippetTableViewOutlet.selectedRow >= 0){ //Only runs if an item is selected, not deselected
        let selectedItem = self.snippetTableViewOutlet.selectedRow
        print(selectedItem)
        self.snippetTableViewOutlet.deselectRow(self.snippetTableViewOutlet.selectedRow)
        }
    }
    
}
