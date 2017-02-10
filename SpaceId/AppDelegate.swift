import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, ReloadDelegate {
    
    let spaceIdentifier = SpaceIdentifier()
    let observer = Observer()
    let statusItem = StatusItem()
    let buttonImage = ButtonImage()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.delegate = self
        NSApp.setActivationPolicy(.accessory)
        observer.setupObservers(using: updateSpaceNumber)
        statusItem.createMenu()
        updateSpaceNumber(())
    }
    
    func reload() {
        observer.setupObservers(using: updateSpaceNumber)
        statusItem.createMenu()
        updateSpaceNumber(())
    }
    
    private func updateSpaceNumber(_ : Any) {
        usleep(10000)
        let info = spaceIdentifier.getSpaceInfo()
        statusItem.updateMenuImage(spaceInfo: info)
    }
}

protocol ReloadDelegate {
    func reload()
}

