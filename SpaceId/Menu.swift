//
//  Menu.swift
//  SpaceId
//
//  Created by Dennis Kao on 8/2/17.
//  Copyright © 2017 Dennis Kao. All rights reserved.
//

import Cocoa
import Foundation

class Menu: NSObject, NSMenuDelegate {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: 27)
    
    func createMenu() {
        statusItem.menu = menuItems()
    }
    
    func updateMenuImage(image: NSImage) {
        statusItem.button?.image = image
    }
    
    func menuItems() -> NSMenu {
        let menu = NSMenu()
        let pref = NSMenuItem(title: "Preferences", action: nil, keyEquivalent: "")
        let opt = NSMenuItem(title: "Options", action: nil, keyEquivalent: "")
        menu.addItem(pref)
        menu.setSubmenu(preferenceMenu(), for: pref)
        menu.addItem(opt)
        menu.setSubmenu(optionMenu(), for: opt)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitButton(_:)), keyEquivalent: ""))
        return menu
    }
    
    private func preferenceMenu() -> NSMenu {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "One Icon", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Icon Per Monitor", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Icon Per Space", action: nil, keyEquivalent: ""))
        return menu
    }
    
    private func optionMenu() -> NSMenu {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "One Icon Multi Monitor Support", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Update on Left Click", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Update on Application Switch", action: nil, keyEquivalent: ""))
        return menu
    }
    
    func quitButton(_ sender: NSMenuItem) {
        NSApp.terminate(self)
    }
    
}
