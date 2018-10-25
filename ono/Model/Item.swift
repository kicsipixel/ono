//
//  Item.swift
//  ono
//
//  Created by Szabolcs Toth on 6/19/17.
//  Copyright © 2017 purzelbaum.hu. All rights reserved.
//

import Cocoa

class Item: NSObject {
    let featureCode: String
    let quantity: String
    let desc: String
    let header: Bool
    let mainLine: Bool
    let subLine: Bool
    let isHardware: Bool
    
    init(featureCode: String, quantity: String, desc: String, header: Bool, mainLine: Bool, subLine: Bool, isHardware: Bool) {
        self.featureCode = featureCode
        self.quantity = quantity
        self.desc = desc
        self.header = header
        self.mainLine = mainLine
        self.subLine = subLine
        self.isHardware = isHardware
    }
}
