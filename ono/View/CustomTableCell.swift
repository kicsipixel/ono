//
//  CustomTableCell.swift
//  ono
//
//  Created by Szabolcs Toth on 6/22/17.
//  Copyright © 2017 purzelbaum.hu. All rights reserved.
//

import Cocoa

class CustomTableCell: NSTableCellView {

    @IBOutlet var imageCell: NSImageView!
    @IBOutlet var featureCodeCell: NSTextField!
    @IBOutlet var descriptionCell: NSTextField!
    @IBOutlet var qtyCell: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
