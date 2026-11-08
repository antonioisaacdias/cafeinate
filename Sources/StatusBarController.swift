import AppKit

final class StatusBarController: NSObject {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let toggleItem = NSMenuItem(title: "", action: #selector(toggle), keyEquivalent: "")
    private let settingsItem = NSMenuItem(title: "", action: #selector(openSettings), keyEquivalent: ",")
    private let quitItem = NSMenuItem(title: "", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
    private let wakeLock: WakeLock
    private let preferences: Preferences
    private let onOpenSettings: () -> Void

    init(wakeLock: WakeLock, preferences: Preferences, onOpenSettings: @escaping () -> Void) {
        self.wakeLock = wakeLock
        self.preferences = preferences
        self.onOpenSettings = onOpenSettings
        super.init()

        toggleItem.target = self
        settingsItem.target = self

        let menu = NSMenu()
        menu.addItem(toggleItem)
        menu.addItem(.separator())
        menu.addItem(settingsItem)
        menu.addItem(quitItem)
        statusItem.menu = menu

        refresh()
    }

    func refresh() {
        let active = wakeLock.isActive
        let strings = preferences.strings
        let image = NSImage(
            systemSymbolName: active ? "cup.and.saucer.fill" : "cup.and.saucer",
            accessibilityDescription: active ? strings.tooltipActive : strings.tooltipInactive
        )
        image?.isTemplate = true
        statusItem.button?.image = image
        statusItem.button?.toolTip = active ? strings.tooltipActive : strings.tooltipInactive
        toggleItem.title = active ? strings.turnOff : strings.turnOn
        toggleItem.state = active ? .on : .off
        settingsItem.title = strings.settings
        quitItem.title = strings.quit
    }

    @objc private func toggle() {
        wakeLock.setActive(!wakeLock.isActive)
        preferences.wasActive = wakeLock.isActive
        refresh()
    }

    @objc private func openSettings() {
        onOpenSettings()
    }
}
