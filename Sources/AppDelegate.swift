import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let wakeLock = WakeLock()
    private let preferences = Preferences()
    private var statusBar: StatusBarController?
    private lazy var settingsWindow = SettingsWindowController(preferences: preferences) { [weak self] in
        self?.statusBar?.refresh()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        if preferences.restoreState && preferences.wasActive {
            wakeLock.setActive(true)
        }
        statusBar = StatusBarController(wakeLock: wakeLock, preferences: preferences) { [weak self] in
            self?.settingsWindow.present()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        wakeLock.setActive(false)
    }
}
