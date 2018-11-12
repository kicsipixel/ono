//
//  MainWindowController.swift
//  ono
//
//  Created by Szabolcs Toth on 10/23/18.
//  Copyright © 2018 purzelbaum.hu. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    var toolbar: NSToolbar!
    var inDarkMode: Bool {
        let mode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
        return mode == "Dark"
    }
    
    let toolbarItems: [[String: String]] = [
        ["title": "group", "icon": "", "identifier": "NavigationGroupToolbarItem"]
    ]
    
    var toolbarTabsIdentifiers: [NSToolbarItem.Identifier] {
        return toolbarItems
            .compactMap { $0["identifier"] }
            .map{ NSToolbarItem.Identifier(rawValue: $0) }
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.configureWindowAppearance()
    }
    
    private func configureWindowAppearance() {
        if let window = window {
            if let view = window.contentView {
                view.wantsLayer = true
                
                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = true
                if inDarkMode {
                    window.backgroundColor = .black
                } else {
                    window.backgroundColor = .white
                }
                
                toolbar = NSToolbar(identifier: "ToolbarIdentifier")
                toolbar.allowsUserCustomization = false
                toolbar.delegate = self
                
                self.window?.toolbar = toolbar
            }
        }
    }

}

extension MainWindowController: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        guard let infoDictionary: [String : String] = toolbarItems.filter({ $0["identifier"] == itemIdentifier.rawValue }).first
            else { return nil }
        
        let toolbarItem: NSToolbarItem
        
        if itemIdentifier.rawValue == "NavigationGroupToolbarItem" {
            
            let group = NSToolbarItemGroup(itemIdentifier: itemIdentifier)
            
            let itemA = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "LoadToolbarItem"))
            itemA.label = "Load"
            let itemB = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "SaveToolbarItem"))
            itemB.label = "Save"
            
            let segmented = NSSegmentedControl(frame: NSRect(x: 0, y: 0, width: 85, height: 40))
            segmented.segmentStyle = .texturedRounded
            segmented.trackingMode = .momentary
            segmented.segmentCount = 2
            
            segmented.setImage(Onoicons.imageOfOpeningFile, forSegment: 0)
            segmented.setWidth(40, forSegment: 0)
            segmented.setImage(Onoicons.imageOfSavingFile, forSegment: 1)
            segmented.setWidth(40, forSegment: 1)
            
            group.paletteLabel = "Navigation"
            group.subitems = [itemA, itemB]
            group.view = segmented
            
            toolbarItem = group
            toolbarItem.action = #selector(ViewController.buttonPressed(sender:))
        } else {
            toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.label = infoDictionary["title"]!
            
            let iconImage = NSImage(named: infoDictionary["icon"]!)
            let button = NSButton(frame: NSRect(x: 0, y: 0, width: 40, height: 40))
            button.title = ""
            button.image = iconImage
            button.bezelStyle = .texturedRounded
            toolbarItem.view = button
        }
        
        return toolbarItem
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.toolbarTabsIdentifiers
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.toolbarDefaultItemIdentifiers(toolbar)
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.toolbarDefaultItemIdentifiers(toolbar)
    }
    
    func toolbarWillAddItem(_ notification: Notification) {
   //     print("toolbarWillAddItem", (notification.userInfo?["item"] as? NSToolbarItem)?.itemIdentifier ?? "")
    }
    
    func toolbarDidRemoveItem(_ notification: Notification) {
  //      print("toolbarDidRemoveItem", (notification.userInfo?["item"] as? NSToolbarItem)?.itemIdentifier ?? "")
    }
    
}
