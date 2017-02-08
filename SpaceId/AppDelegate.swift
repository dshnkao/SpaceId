import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    
    let spaceIdentifier = SpaceIdentifier()
    let observer = Observer()
    let menu = Menu()
    let buttonImage = ButtonImage()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        observer.addActiveWorkSpaceEvent(using: updateSpaceNumber)
        observer.addActiveApplicationEvent(using: updateSpaceNumber)
        observer.addLeftMouseClickEvent(handler: updateSpaceNumber)
        menu.createMenu()
        updateSpaceNumber(())
    }
    
    private func updateSpaceNumber(_ : Any) {
        usleep(10000)
        let number = spaceIdentifier.getActiveSpaceNumber()
        menu.updateMenuImage(image: buttonImage.filledSquare(text: String(number)))
        print(number)
    }
}

