//
//  AppDelegate.swift
//  ono
//
//  Created by Szabolcs Toth on 10/23/18.
//  Copyright © 2018 purzelbaum.hu. All rights reserved.
//

import Cocoa
import HockeySDK

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        BITHockeyManager.shared().configure(withIdentifier: "5d69b34194024f6a8da34621598d009e")
        // Do some additional configuration if needed here
        BITHockeyManager.shared().start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

