import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let spaceIdentifier = SpaceIdentifier()
    let observer = Observer()
    let statusItem = StatusItem()
    let buttonImage = ButtonImage()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        observer.addActiveWorkSpaceEvent(using: updateSpaceNumber)
        observer.addActiveApplicationEvent(using: updateSpaceNumber)
        observer.addLeftMouseClickEvent(handler: updateSpaceNumber)
        statusItem.createMenu()
        updateSpaceNumber(())
    }
    
    private func updateSpaceNumber(_ : Any) {
        usleep(10000)
        let number = spaceIdentifier.getActiveSpaceNumber()
        statusItem.updateMenuImage(spaceNumber: number)
        print(number)
    }
}

