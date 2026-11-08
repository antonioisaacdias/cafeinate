import Foundation
import ServiceManagement

final class Preferences {
    private enum Keys {
        static let restoreState = "restoreState"
        static let wasActive = "wasActive"
    }

    private let defaults = UserDefaults.standard

    var restoreState: Bool {
        get { defaults.bool(forKey: Keys.restoreState) }
        set { defaults.set(newValue, forKey: Keys.restoreState) }
    }

    var wasActive: Bool {
        get { defaults.bool(forKey: Keys.wasActive) }
        set { defaults.set(newValue, forKey: Keys.wasActive) }
    }

    var launchAtLogin: Bool {
        SMAppService.mainApp.status == .enabled
    }

    func setLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            NSLog("Login item change failed: \(error)")
        }
        if SMAppService.mainApp.status == .requiresApproval {
            SMAppService.openSystemSettingsLoginItems()
        }
    }
}
