import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: 27)
    let spaceIdentifier = SpaceIdentifier()
    let buttonImage = ButtonImage()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        addActiveWorkSpaceEvent()
        addActiveApplicationEvent()
        addLeftMouseClickEvent()
        addMenuItems()
        updateSpaceNumber(())
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        NSApp.terminate(self)
    }
    
    private func updateSpaceNumber(_ : Any) {
        usleep(10000)
        let number = spaceIdentifier.getActiveSpaceNumber()
        statusItem.button?.image = buttonImage.filledSquare(text: String(number))
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
    
    private func addMenuItems() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Preferences", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Options", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitButton(_:)), keyEquivalent: ""))
        statusItem.menu = menu
    }
    
    func quitButton(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
}

