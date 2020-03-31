//
//  AppDelegate.swift
//  Bitstamp Price
//
//  Created by Sebas on 08/12/17.
//  Copyright © 2017 WasabitLabs. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  @IBOutlet weak var menu: NSMenu!
  
  let bitstamp = Bitstamp()
  let statusItem = NSStatusBar.system
    .statusItem(withLength: NSStatusItem.variableLength)
  
  var fetchTimer: Timer!
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if #available(OSX 10.12.2, *) {
      NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
    }
    
    statusItem.menu = menu
    statusItem.title = "Fetching..."
    
    updatePrice()
    
    fetchTimer = Timer.scheduledTimer(timeInterval: 30,
                                      target: self,
                                      selector: #selector(updatePrice),
                                      userInfo: nil,
                                      repeats: true)
  }
  
  @objc func updatePrice() {
    bitstamp.showPrice { (price) in
      self.statusItem.attributedTitle = price
    }
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    fetchTimer.invalidate()
  }
}
