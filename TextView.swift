//
//  TextView.swift
//  Cards
//
//  Created by Michael Buss Andersen on 27/03/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

class TextView: NSTextView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.textContainerInset = NSSize(width: 5, height: 5)
        
        // Drawing code here.
    }
    
}
