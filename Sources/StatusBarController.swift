import AppKit

final class StatusBarController: NSObject {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let toggleItem = NSMenuItem(title: "Ligar", action: #selector(toggle), keyEquivalent: "")
    private let wakeLock: WakeLock
    private let preferences: Preferences
    private let onOpenSettings: () -> Void

    init(wakeLock: WakeLock, preferences: Preferences, onOpenSettings: @escaping () -> Void) {
        self.wakeLock = wakeLock
        self.preferences = preferences
        self.onOpenSettings = onOpenSettings
        super.init()

        toggleItem.target = self

        let settingsItem = NSMenuItem(title: "Configurações…", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self

        let menu = NSMenu()
        menu.addItem(toggleItem)
        menu.addItem(.separator())
        menu.addItem(settingsItem)
        menu.addItem(withTitle: "Sair", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        statusItem.menu = menu

        refresh()
    }

    @objc private func toggle() {
        wakeLock.setActive(!wakeLock.isActive)
        preferences.wasActive = wakeLock.isActive
        refresh()
    }

    @objc private func openSettings() {
        onOpenSettings()
    }

    private func refresh() {
        let active = wakeLock.isActive
        let image = NSImage(
            systemSymbolName: active ? "cup.and.saucer.fill" : "cup.and.saucer",
            accessibilityDescription: active ? "Tela ligada" : "Normal"
        )
        image?.isTemplate = true
        statusItem.button?.image = image
        statusItem.button?.toolTip = active ? "Tela sempre ligada" : "Comportamento normal"
        toggleItem.title = active ? "Desligar" : "Ligar"
        toggleItem.state = active ? .on : .off
    }
}
