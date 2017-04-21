//
//  SnippetCell.swift
//  Cards
//
//  Created by Michael Buss Andersen on 19/04/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

class SnippetCell: NSTableCellView {

    @IBOutlet weak var snippetTitle: NSTextField!
    @IBOutlet weak var snippetImage: NSImageView!
    
    func cellSetup(image: NSImage, title: String) {
        snippetTitle.stringValue = title
        snippetImage.image = image
    }
    
    
}
