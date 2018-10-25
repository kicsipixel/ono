//
//  xmlModel.swift
//  ono
//
//  Created by Szabolcs Toth on 7/1/16.
//  Copyright © 2016 purzelbaum.hu. All rights reserved.
//

import Foundation
import AEXML

var lineArray: [Item] = []
var lineDictionary: [Item: [Item]] = [:]

func processXML (result: String) {
    
    let path = result
    
    let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        
    do {
        let xmlDoc = try AEXMLDocument(xml: data!)
        
        if let lines = xmlDoc.root["CFData"]["ProductLineItem"].all {
            
        // 1. Collect all lines into an array
            for line in lines {
                if let featureCode = line["ProductIdentification"]["PartnerProductIdentification"]["ProprietaryProductIdentifier"].value {
                    let description = line["ProductIdentification"]["PartnerProductIdentification"]["ProductDescription"].value
                    let productTypeCode = line["ProductIdentification"]["PartnerProductIdentification"]["ProductTypeCode"].value
                    let quantity = line["Quantity"].value
                    
                    if (line["TransactionType"].value! == "NEW" || line["TransactionType"].value! == "FMOD")  {
                        if (line["ProductIdentification"]["PartnerProductIdentification"]["ProprietaryProductIdentifier"].value != "5313-HPO" ) {
                            if (line["ProductIdentification"]["PartnerProductIdentification"]["ProductTypeCode"].value != "Software") {
                            
                                let header = Item(featureCode: featureCode, quantity: quantity!, desc: description!, header: true, mainLine: false, subLine: false, isHardware: true)
                                lineArray.append(header)
                            } else {
                                if (productTypeCode == "Hardware") {
                                    let mainLine = Item(featureCode: featureCode, quantity: quantity!, desc: description!, header: false, mainLine: true, subLine: false, isHardware: true)
                                    lineArray.append(mainLine)
                                } else {
                                    let mainLine = Item(featureCode: featureCode, quantity: quantity!, desc: description!, header: false, mainLine: true, subLine: false, isHardware: false)
                                    lineArray.append(mainLine)
                            }
                        }
                        } else {
                            let mainLine = Item(featureCode: featureCode, quantity: quantity!, desc: description!, header: false, mainLine: true, subLine: false, isHardware: true)
                            lineArray.append(mainLine)
                        }
                    }
                }
                
                    if let sublines = line["ProductSubLineItem"].all {
                        for subline in sublines {
                            let featureCode = subline["ProductIdentification"]["PartnerProductIdentification"]["ProprietaryProductIdentifier"].value
                            let description = subline["ProductIdentification"]["PartnerProductIdentification"]["ProductDescription"].value
                            let productTypeCode = subline["ProductIdentification"]["PartnerProductIdentification"]["ProductTypeCode"].value
                            let quantity = subline["Quantity"].value
                            
                            // TODO: Check if this is needed
                            if(subline["TransactionType"].value! == "ADD") {
                                if (productTypeCode == "Hardware") {
                                    let subLine = Item(featureCode: featureCode!, quantity: quantity!, desc: description!, header: false, mainLine: false, subLine: true, isHardware: true)
                                    lineArray.append(subLine)
                                } else {
                                    let subLine = Item(featureCode: featureCode!, quantity: quantity!, desc: description!, header: false, mainLine: false, subLine: true, isHardware: false)
                                    lineArray.append(subLine)
                                }
                            }
                        }
                    }
                }

        }
    }
    catch {
        print("\(error)")
    }
    
}
