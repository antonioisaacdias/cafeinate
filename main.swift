import AppKit
import IOKit.pwr_mgt
import ServiceManagement

private enum Keys {
    static let restoreState = "restoreState"
    static let wasActive = "wasActive"
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let toggleItem = NSMenuItem(title: "Ligar", action: #selector(toggle), keyEquivalent: "")
    private let defaults = UserDefaults.standard
    private var assertionID: IOPMAssertionID = 0
    private var active = false
    private var settingsWindow: NSWindow?
    private var launchAtLoginBox: NSButton?

    func applicationDidFinishLaunching(_ notification: Notification) {
        toggleItem.target = self

        let settingsItem = NSMenuItem(title: "Configurações…", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self

        let menu = NSMenu()
        menu.addItem(toggleItem)
        menu.addItem(.separator())
        menu.addItem(settingsItem)
        menu.addItem(withTitle: "Sair", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        statusItem.menu = menu

        if defaults.bool(forKey: Keys.restoreState) && defaults.bool(forKey: Keys.wasActive) {
            toggle()
        }
        refresh()
    }

    func applicationWillTerminate(_ notification: Notification) {
        if active {
            IOPMAssertionRelease(assertionID)
        }
    }

    @objc private func toggle() {
        if active {
            IOPMAssertionRelease(assertionID)
            active = false
        } else {
            let result = IOPMAssertionCreateWithName(
                kIOPMAssertionTypePreventUserIdleDisplaySleep as CFString,
                IOPMAssertionLevel(kIOPMAssertionLevelOn),
                "widget-cafeinate" as CFString,
                &assertionID
            )
            active = (result == kIOReturnSuccess)
        }
        defaults.set(active, forKey: Keys.wasActive)
        refresh()
    }

    private func refresh() {
        let name = active ? "cup.and.saucer.fill" : "cup.and.saucer"
        let image = NSImage(systemSymbolName: name, accessibilityDescription: active ? "Tela ligada" : "Normal")
        image?.isTemplate = true
        statusItem.button?.image = image
        statusItem.button?.toolTip = active ? "Tela sempre ligada" : "Comportamento normal"
        toggleItem.title = active ? "Desligar" : "Ligar"
        toggleItem.state = active ? .on : .off
    }

    @objc private func openSettings() {
        if settingsWindow == nil {
            settingsWindow = buildSettingsWindow()
        }
        launchAtLoginBox?.state = SMAppService.mainApp.status == .enabled ? .on : .off
        NSApp.activate(ignoringOtherApps: true)
        settingsWindow?.makeKeyAndOrderFront(nil)
    }

    private func buildSettingsWindow() -> NSWindow {
        let loginBox = NSButton(checkboxWithTitle: "Abrir automaticamente no login", target: self, action: #selector(toggleLaunchAtLogin(_:)))
        launchAtLoginBox = loginBox

        let restoreBox = NSButton(checkboxWithTitle: "Manter o último estado ao reiniciar", target: self, action: #selector(toggleRestoreState(_:)))
        restoreBox.state = defaults.bool(forKey: Keys.restoreState) ? .on : .off

        let stack = NSStackView(views: [loginBox, restoreBox])
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        let container = NSView()
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -24),
            container.widthAnchor.constraint(greaterThanOrEqualToConstant: 320),
        ])

        let window = NSWindow(
            contentRect: .zero,
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Configurações"
        window.contentView = container
        window.setContentSize(container.fittingSize)
        window.isReleasedWhenClosed = false
        window.center()
        return window
    }

    @objc private func toggleLaunchAtLogin(_ sender: NSButton) {
        do {
            if sender.state == .on {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            NSLog("Login item change failed: \(error)")
        }
        let status = SMAppService.mainApp.status
        if status == .requiresApproval {
            SMAppService.openSystemSettingsLoginItems()
        }
        sender.state = status == .enabled ? .on : .off
    }

    @objc private func toggleRestoreState(_ sender: NSButton) {
        defaults.set(sender.state == .on, forKey: Keys.restoreState)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
