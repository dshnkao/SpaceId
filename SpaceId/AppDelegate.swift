//
//  AppDelegate.swift
//  SpaceId
//
//  Created by Dennis Kao on 2/2/17.
//  Copyright © 2017 Dennis Kao. All rights reserved.
//
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    
    //@IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: 27)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        addActiveWorkSpaceEvent()
        addActiveApplicationEvent()
        addLeftMouseClickEvent()
        updateSpaceNumber(())
    }
    func test(_ notification: Notification) {
        print("test")
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        NSApp.terminate(self)
    }
    
    private func updateSpaceNumber(_ : Any) {
        usleep(10000) // wait for com.apple.spaces get updated
        let number = SpaceIdentifier().getActiveSpaceNumber()
        statusItem.button?.image = ButtonImage.sharedInstance.roundedSquare(text: String(number))
        print(number)
    }
    
    private func addActiveWorkSpaceEvent() {
        NSWorkspace.shared()
            .notificationCenter
            .addObserver(
                forName: NSNotification.Name.NSWorkspaceActiveSpaceDidChange,
                object: nil,
                queue: OperationQueue.main,
                using: updateSpaceNumber)
    }
    
    private func addActiveApplicationEvent() {
        NSWorkspace.shared()
            .notificationCenter
            .addObserver(
                forName: NSNotification.Name.NSWorkspaceDidActivateApplication,
                object: nil,
                queue: OperationQueue.main, using: updateSpaceNumber)
    }
    
    private func addLeftMouseClickEvent() {
        NSEvent.addGlobalMonitorForEvents(matching: NSEventMask.leftMouseDown, handler: updateSpaceNumber)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
}

