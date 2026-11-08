import Foundation
import ServiceManagement

final class Preferences {
    private enum Keys {
        static let restoreState = "restoreState"
        static let wasActive = "wasActive"
        static let language = "language"
        static let hideWhenInControlCenter = "hideWhenInControlCenter"
    }

    private let defaults = UserDefaults.standard

    var language: Language {
        get { defaults.string(forKey: Keys.language).flatMap(Language.init(rawValue:)) ?? .systemDefault }
        set { defaults.set(newValue.rawValue, forKey: Keys.language) }
    }

    var strings: Strings {
        Strings.of(language)
    }

    var restoreState: Bool {
        get { defaults.bool(forKey: Keys.restoreState) }
        set { defaults.set(newValue, forKey: Keys.restoreState) }
    }

    var hideWhenInControlCenter: Bool {
        get { defaults.object(forKey: Keys.hideWhenInControlCenter) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.hideWhenInControlCenter) }
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
