import Cocoa
import Foundation

class StatusItem: NSObject, NSMenuDelegate {
    
    private let item = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    private let defaults = UserDefaults.standard
    private let buttonImage = ButtonImage()
    private var currentSpaceInfo = SpaceInfo(keyboardFocusSpace: nil, spaces: [])
    
    func createMenu() {
        item.menu = menuItems()
    }
    
    func updateMenuImage(spaceInfo: SpaceInfo) {
        currentSpaceInfo = spaceInfo
        item.button?.image = buttonImage.createImage(spaceInfo: spaceInfo)
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
        
        switch defaults.integer(forKey: Preference.icon) {
        case 0: oneIcon.state = NSOnState
        case 1: perMonitor.state = NSOnState
        case 2: perSpace.state = NSOnState
        default: break
        }
        
        switch defaults.integer(forKey: Preference.color) {
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

        leftClick.target = self
        appSwitch.target = self
        
        leftClick.state = defaults.bool(forKey: Preference.App.updateOnLeftClick.rawValue) ? NSOnState : NSOffState
        appSwitch.state = defaults.bool(forKey: Preference.App.updateOnAppSwitch.rawValue) ? NSOnState : NSOffState
        
        menu.addItem(NSMenuItem(title: "One Icon Multi Monitor Support", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(leftClick)
        menu.addItem(appSwitch)
        return menu
    }
    
    func oneIcon(_ sender: NSMenuItem) {
        defaults.set(Preference.Icon.one.rawValue, forKey: Preference.icon)
        createMenu()
        updateMenuImage(spaceInfo: currentSpaceInfo)
    }
    
    func iconPerMonitor(_ sender: NSMenuItem) {
        defaults.set(Preference.Icon.perMonitor.rawValue, forKey: Preference.icon)
        createMenu()
        updateMenuImage(spaceInfo: currentSpaceInfo)
    }
    
    func iconPerSpace(_ sender: NSMenuItem) {
        defaults.set(Preference.Icon.perSpace.rawValue, forKey: Preference.icon)
        createMenu()
        updateMenuImage(spaceInfo: currentSpaceInfo)
    }
    
    func whiteOnBlack(_ sender: NSMenuItem) {
        defaults.set(Preference.Color.whiteOnBlack.rawValue, forKey: Preference.color)
        createMenu()
        updateMenuImage(spaceInfo: currentSpaceInfo)
    }
    
    func blackOnWhite(_ sender: NSMenuItem) {
        defaults.set(Preference.Color.blackOnWhite.rawValue, forKey: Preference.color)
        createMenu()
        updateMenuImage(spaceInfo: currentSpaceInfo)
    }
    
    func updateOnLeftClick(_ sender: NSMenuItem) {
        let b = defaults.bool(forKey: Preference.App.updateOnLeftClick.rawValue)
        defaults.set(!b, forKey: Preference.App.updateOnLeftClick.rawValue)
        createMenu()
    }

    func updateOnAppSwitch(_ sender: NSMenuItem) {
        let b = defaults.bool(forKey: Preference.App.updateOnAppSwitch.rawValue)
        defaults.set(!b, forKey: Preference.App.updateOnAppSwitch.rawValue)
        createMenu()
    }
    
    func quit(_ sender: NSMenuItem) {
        NSApp.terminate(self)
    }
    
}

