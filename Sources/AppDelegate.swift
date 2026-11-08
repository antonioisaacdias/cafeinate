import AppKit
import WidgetKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let wakeLock = WakeLock()
    private let preferences = Preferences()
    private var statusBar: StatusBarController?
    private var controlCenter: ControlCenterBridge?
    private var visibilityTimer: Timer?
    private lazy var settingsWindow = SettingsWindowController(preferences: preferences) { [weak self] in
        self?.statusBar?.refresh()
    } onIconVisibilityChange: { [weak self] in
        self?.updateIconVisibility()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        if preferences.restoreState && preferences.wasActive {
            wakeLock.setActive(true)
        }
        statusBar = StatusBarController(wakeLock: wakeLock, preferences: preferences) { [weak self] in
            self?.settingsWindow.present()
        } onToggle: { [weak self] in
            guard let self else {
                return
            }
            self.setAwake(!self.wakeLock.isActive)
        }
        controlCenter = ControlCenterBridge { [weak self] active in
            self?.setAwake(active)
        }
        controlCenter?.publish(wakeLock.isActive)

        updateIconVisibility()
        visibilityTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.updateIconVisibility()
        }

        if !launchedAsLoginItem {
            settingsWindow.present()
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        settingsWindow.present()
        return true
    }

    func applicationWillTerminate(_ notification: Notification) {
        wakeLock.setActive(false)
        controlCenter?.publish(false)
    }

    private var launchedAsLoginItem: Bool {
        let event = NSAppleEventManager.shared().currentAppleEvent
        let launchReason = event?.paramDescriptor(forKeyword: keyAEPropData)?.enumCodeValue
        return launchReason == keyAELaunchedAsLogInItem
    }

    private func setAwake(_ active: Bool) {
        wakeLock.setActive(active)
        preferences.wasActive = wakeLock.isActive
        statusBar?.refresh()
        controlCenter?.publish(wakeLock.isActive)
    }

    private func updateIconVisibility() {
        guard #available(macOS 26.0, *), preferences.hideWhenInControlCenter else {
            statusBar?.setVisible(true)
            return
        }
        Task { @MainActor [weak self] in
            let controls = (try? await ControlCenter.shared.currentControls()) ?? []
            let inControlCenter = controls.contains { $0.kind == ControlChannel.controlKind }
            self?.statusBar?.setVisible(!inControlCenter)
        }
    }
}
