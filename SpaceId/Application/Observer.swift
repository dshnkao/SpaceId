import Cocoa
import Foundation

class Observer {
    
    let defaults = UserDefaults.standard
    let center = NSWorkspace.shared().notificationCenter
    var workspace = false
    var monitor = false
    var activeApp: NSObjectProtocol?
    var leftMouseClick: Any?
    
    func setupObservers(using: @escaping (Any) -> Void) {
        removeActiveApplicationEvent()
        removeLeftMouseClickEvent()
        if !workspace {
            addActiveWorkSpaceEvent(using: using)
            workspace = true
        }
        if !monitor {
            addMonitorEvent(using: using)
            monitor = true
        }
        
        if defaults.bool(forKey: Preference.App.updateOnAppSwitch.rawValue) {
            addActiveApplicationEvent(using: using)
        }
        if defaults.bool(forKey: Preference.App.updateOnLeftClick.rawValue) {
            addLeftMouseClickEvent(handler: using)
        }
    }
    
    private func addActiveWorkSpaceEvent(using: @escaping (Notification) -> Void) {
        center.addObserver(
                forName: NSNotification.Name.NSWorkspaceActiveSpaceDidChange,
                object: nil,
                queue: OperationQueue.main,
                using: using)
    }
    
    private func addMonitorEvent(using: @escaping (Notification) -> Void) {
        center.addObserver(
            forName: NSNotification.Name.NSApplicationDidChangeScreenParameters,
            object: nil,
            queue: OperationQueue.main,
            using: using)
    }
    
    private func addActiveApplicationEvent(using: @escaping (Notification) -> Void) {
        activeApp = center.addObserver(
                forName: NSNotification.Name.NSWorkspaceDidActivateApplication,
                object: nil,
                queue: OperationQueue.main, using: using)
    }
    
    private func addLeftMouseClickEvent(handler: @escaping (NSEvent) -> Void) {
        leftMouseClick = NSEvent.addGlobalMonitorForEvents(matching: NSEventMask.leftMouseDown, handler: handler)
    }
    
    private func removeActiveApplicationEvent() {
        if let observer = activeApp {
            center.removeObserver(observer,
                                  name: NSNotification.Name.NSWorkspaceDidActivateApplication,
                                  object: nil)
            activeApp = nil
        }
    }
    
    private func removeLeftMouseClickEvent() {
        if let monitor = leftMouseClick {
            NSEvent.removeMonitor(monitor)
            leftMouseClick = nil
        }
    }
    
    

}
