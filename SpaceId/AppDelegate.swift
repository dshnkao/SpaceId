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
        setLoginItem()
        statusItem.createMenu()
        updateSpaceNumber(())
    }
    
    func reload() {
        observer.setupObservers(using: updateSpaceNumber)
        setLoginItem()
        statusItem.createMenu()
        updateSpaceNumber(())
    }
    
    private func updateSpaceNumber(_ : Any) {
        usleep(10000)
        let info = spaceIdentifier.getSpaceInfo()
        statusItem.updateMenuImage(spaceInfo: info)
    }
    
    private func setLoginItem() {
        let b = UserDefaults.standard.bool(forKey: Preference.App.launchOnLogin.rawValue)
        let path = Bundle.main.bundlePath
        let add = "tell application \"System Events\" to make login item at end with properties {name: \"SpaceId\",path:\"\(path)\", hidden:true}"
        let remove = "tell application \"System Events\" to delete login item \"SpaceId\""
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = b ? ["-e", add] : ["-e", remove]
        task.launch()
    }
}

protocol ReloadDelegate {
    func reload()
}

