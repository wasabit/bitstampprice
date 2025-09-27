//
//  AppDelegate.swift
//  Bitstamp Price
//
//  Created by Sebas on 08/12/17.
//  Copyright © 2017 WasabitLabs. All rights reserved.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var menu: NSMenu!

    private let bitstamp = Bitstamp()
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var fetchTimer: Timer?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupStatusItem()
        startPeriodicUpdates()
    }

    private func setupStatusItem() {
        statusItem.menu = menu
        statusItem.button?.title = "₿ Fetching..."

        // Configure the button for better vertical alignment
        if let button = statusItem.button {
            button.imagePosition = .noImage
            button.alignment = .center
        }

        // Add a quit menu item if not already present
        if menu.items.isEmpty {
            let quitMenuItem = NSMenuItem(title: "Quit Bitstamp Price", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
            menu.addItem(quitMenuItem)
        }
    }

    private func startPeriodicUpdates() {
        // Initial update
        updatePrice()

        // Schedule periodic updates every 30 seconds
        fetchTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.updatePrice()
        }
    }

    @objc private func updatePrice() {
        bitstamp.showPrice { [weak self] price in
            DispatchQueue.main.async {
                self?.statusItem.button?.attributedTitle = price
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        fetchTimer?.invalidate()
        fetchTimer = nil
    }

    // Add menu actions
    @IBAction func refreshPrice(_ sender: Any) {
        updatePrice()
    }
}
