//
//  ViewController.swift
//  ono
//
//  Created by Szabolcs Toth on 10/23/18.
//  Copyright © 2018 purzelbaum.hu. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var tableView: NSTableView!
    var path: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sparkle update
        let defaults = UserDefaults.standard
        defaults.set("https://rink.hockeyapp.net/api/2/apps/5d69b34194024f6a8da34621598d009e", forKey: "SUFeedURL")
        
        // Notification center
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.refreshTableView), name: NSNotification.Name(rawValue: "refresh"), object: nil)

    }
    
    @objc func refreshTableView() {
        tableView.reloadData()
    }
    
    @objc func openFromFile() {
        
        let dialog = NSOpenPanel()
        
        dialog.title                                      = "Choose a .xml file";
        dialog.showsResizeIndicator          = true;
        dialog.showsHiddenFiles               = false;
        dialog.canChooseDirectories         = true;
        dialog.canCreateDirectories           = true;
        dialog.allowsMultipleSelection      = false;
        dialog.allowedFileTypes                 = ["xml"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url
            
            if (result != nil) {
                path = result!.path
                
                processXML(result: path)
                
            } else {
                // User clicked on "Cancel"
                return
            }
        }
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
    @objc func buttonPressed(sender: AnyObject) {
            
            switch(sender.selectedSegment) {
            case 0:
                openFromFile()
                
            case 1:
                saveToFile()
                
            default:
                break
            }
            
        }
    
    @objc func saveToFile() {
        
        let preArray: NSMutableArray = []
        
        if responseArray.count != 0 {
            
            // Prepare array for writing
            for line in responseArray {
                let FC = line.featureCode
                let DESC  = line.desc
                let QTY  = line.quantity
                preArray.add("\(FC)\t\(DESC)\t\(QTY)")
            }
            
            let arrayToWrite = preArray as AnyObject as! [String]
            
            let joined = arrayToWrite.joined(separator: "\n")
            
            // Opening save panel
            let savePanel = NSSavePanel()
            let filename = (path as NSString).lastPathComponent
            savePanel.nameFieldStringValue = "\(filename).tsv"
            savePanel.begin { (result)  -> Void in
                if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                    let exportedFileURL = savePanel.url
                    let data = joined.data(using: String.Encoding.utf8)
                    
                    FileManager.default.createFile(atPath: exportedFileURL!.path, contents: data, attributes: nil)
                }
            }
        }
        else {
            let alert = NSAlert()
            alert.messageText = "No XML, no PARTY!"
            alert.addButton(withTitle: "OK")
            alert.informativeText = "Please, load an .xml file first."
            
            alert.beginSheetModal(for: self.view.window!, completionHandler: nil )
        }
    }
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return responseArray.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let vw = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? CustomTableCell else { return nil }
        
        tableView.selectionHighlightStyle = .none
        
        vw.featureCodeCell.stringValue = responseArray[row].featureCode
        vw.descriptionCell.stringValue = responseArray[row].desc
        vw.qtyCell.stringValue = responseArray[row].quantity
        
        if !(responseArray[row].header || responseArray[row].mainLine) {
            vw.imageCell.image = nil
        } else {
            if (responseArray[row].isHardware) {
                vw.imageCell.image = Onoicons.imageOfHardware
            } else {
                vw.imageCell.image = Onoicons.imageOfSoftware
            }
        }
        
        return vw
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return CGFloat(50.0)
    }
    
}

