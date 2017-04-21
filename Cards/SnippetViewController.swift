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
    
    let snippetModel = SnippetModel()
    
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
        if let cell = tableView.make(withIdentifier: "cell", owner: nil) as? NSTableCellView {
            
            if cellText.count >= cellImages.count{ // Checks if there are enough snippets in the array to match images
            cell.textField?.stringValue = cellText[row]
            } else {cell.textField?.stringValue = "Missing description"}
            
            if cellImages.count >= cellText.count { // Checks if there are enough images in the array to match snippets
            cell.imageView?.image = cellImages[row]
            } else {cell.imageView?.image = #imageLiteral(resourceName: "Snippets_Missing")}
            
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
