//
//  Observer.swift
//  SpaceId
//
//  Created by Dennis Kao on 8/2/17.
//  Copyright © 2017 Dennis Kao. All rights reserved.
//

import Cocoa
import Foundation

class Observer {
    
    func addActiveWorkSpaceEvent(using: @escaping (Notification) -> Void) {
        NSWorkspace.shared()
            .notificationCenter
            .addObserver(
                forName: NSNotification.Name.NSWorkspaceActiveSpaceDidChange,
                object: nil,
                queue: OperationQueue.main,
                using: using)
    }
    
    
    func addActiveApplicationEvent(using: @escaping (Notification) -> Void) {
        NSWorkspace.shared()
            .notificationCenter
            .addObserver(
                forName: NSNotification.Name.NSWorkspaceDidActivateApplication,
                object: nil,
                queue: OperationQueue.main, using: using)
    }
    
    func addLeftMouseClickEvent(handler: @escaping (NSEvent) -> Void) {
        NSEvent.addGlobalMonitorForEvents(matching: NSEventMask.leftMouseDown, handler: handler)
    }

}
