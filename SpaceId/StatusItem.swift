import Cocoa
import Foundation

class StatusItem: NSObject, NSMenuDelegate {
    
    let item = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let defaults = UserDefaults.standard
    let buttonImage = ButtonImage()
    var currentSpaceNumber = 0
    
    func createMenu() {
        item.menu = menuItems()
    }
    
    func updateMenuImage(spaceNumber: Int) {
        currentSpaceNumber = spaceNumber
        item.button?.image = buttonImage.createImage(text: String(spaceNumber))
    }
    
    func menuItems() -> NSMenu {
        let menu = NSMenu()
        let pref = NSMenuItem(title: "Preferences", action: nil, keyEquivalent: "")
        let opt = NSMenuItem(title: "Options", action: nil, keyEquivalent: "")
        let quit = NSMenuItem(title: "Quit", action: #selector(quit(_:)), keyEquivalent: "")
        quit.target = self
        menu.addItem(pref)
        menu.setSubmenu(preferenceMenu(), for: pref)
        menu.addItem(opt)
        menu.setSubmenu(optionMenu(), for: opt)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quit)
        return menu
    }
    
    private func preferenceMenu() -> NSMenu {
        let menu = NSMenu()
        let oneIcon = NSMenuItem(title: "One Icon",
                                 action: #selector(oneIcon(_:)),
                                 keyEquivalent: "")
        let perMonitor = NSMenuItem(title: "Icon Per Monitor",
                                    action: #selector(iconPerMonitor(_:)),
                                    keyEquivalent: "")
        let perSpace = NSMenuItem(title: "Icon Per Space",
                                  action: #selector(iconPerSpace(_:)),
                                  keyEquivalent: "")
        let fill = NSMenuItem(title: "White on Black",
                              action: #selector(whiteOnBlack(_:)),
                              keyEquivalent: "")
        let empty = NSMenuItem(title: "Black on White",
                               action: #selector(blackOnWhite(_:)),
                               keyEquivalent: "")
        oneIcon.target = self
        perMonitor.target = self
        perSpace.target = self
        fill.target = self
        empty.target = self
        
        switch defaults.integer(forKey: "IconOption") {
        case 0: oneIcon.state = NSOnState
        case 1: perMonitor.state = NSOnState
        case 2: perSpace.state = NSOnState
        default: break
        }
        
        switch defaults.integer(forKey: "ColorOption") {
        case 0: fill.state = NSOnState
        case 1: empty.state = NSOnState
        default: break
        }
        
        menu.addItem(oneIcon)
        menu.addItem(perMonitor)
        menu.addItem(perSpace)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(fill)
        menu.addItem(empty)
        return menu
    }
    
    private func optionMenu() -> NSMenu {
        let menu = NSMenu()
        let leftClick = NSMenuItem(title: "Update on Left Click",
                                   action: #selector(updateOnLeftClick(_:)),
                                   keyEquivalent: "")
        let appSwitch = NSMenuItem(title: "Update on Application Switch",
                                   action: #selector(updateOnAppSwitch(_:)),
                                   keyEquivalent: "")
        let fullscreen = NSMenuItem(title: "Ignore Fullscreen Apps",
                                    action: #selector(ignoreFullscreenApps(_:)),
                                    keyEquivalent: "")
        leftClick.target = self
        appSwitch.target = self
        fullscreen.target = self
        
        leftClick.state = defaults.bool(forKey: AppOption.updateOnLeftClick.rawValue) ? NSOnState : NSOffState
        appSwitch.state = defaults.bool(forKey: AppOption.updateOnAppSwitch.rawValue) ? NSOnState : NSOffState
        fullscreen.state = defaults.bool(forKey: AppOption.ignoreFullscreenApps.rawValue) ? NSOnState : NSOffState
        
        menu.addItem(NSMenuItem(title: "One Icon Multi Monitor Support", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(leftClick)
        menu.addItem(appSwitch)
        menu.addItem(fullscreen)
        return menu
    }
    
    func oneIcon(_ sender: NSMenuItem) {
        defaults.set(IconOption.oneIcon.rawValue, forKey: "IconOption")
        createMenu()
        updateMenuImage(spaceNumber: currentSpaceNumber)
    }
    
    func iconPerMonitor(_ sender: NSMenuItem) {
        defaults.set(IconOption.iconPerMonitor.rawValue, forKey: "IconOption")
        createMenu()
        updateMenuImage(spaceNumber: currentSpaceNumber)
    }
    
    func iconPerSpace(_ sender: NSMenuItem) {
        defaults.set(IconOption.iconPerSpace.rawValue, forKey: "IconOption")
        createMenu()
        updateMenuImage(spaceNumber: currentSpaceNumber)
    }
    
    func whiteOnBlack(_ sender: NSMenuItem) {
        defaults.set(ColorOption.whiteOnBlack.rawValue, forKey: "ColorOption")
        createMenu()
        updateMenuImage(spaceNumber: currentSpaceNumber)
    }
    
    func blackOnWhite(_ sender: NSMenuItem) {
        defaults.set(ColorOption.blackOnWhite.rawValue, forKey: "ColorOption")
        createMenu()
        updateMenuImage(spaceNumber: currentSpaceNumber)
    }
    
    func updateOnLeftClick(_ sender: NSMenuItem) {
        let b = defaults.bool(forKey: AppOption.updateOnLeftClick.rawValue)
        defaults.set(!b, forKey: AppOption.updateOnLeftClick.rawValue)
        createMenu()
    }

    func updateOnAppSwitch(_ sender: NSMenuItem) {
        let b = defaults.bool(forKey: AppOption.updateOnAppSwitch.rawValue)
        defaults.set(!b, forKey: AppOption.updateOnAppSwitch.rawValue)
        createMenu()
    }

    func ignoreFullscreenApps(_ sender: NSMenuItem) {
        let b = defaults.bool(forKey: AppOption.ignoreFullscreenApps.rawValue)
        defaults.set(!b, forKey: AppOption.ignoreFullscreenApps.rawValue)
        createMenu()
    }
    
    func quit(_ sender: NSMenuItem) {
        NSApp.terminate(self)
    }
    
}

enum IconOption: Int {
    case oneIcon
    case iconPerMonitor
    case iconPerSpace
}

enum ColorOption: Int {
    case whiteOnBlack
    case blackOnWhite
}

enum AppOption: String {
    case updateOnLeftClick
    case updateOnAppSwitch
    case ignoreFullscreenApps
}
