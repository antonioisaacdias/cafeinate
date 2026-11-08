import Foundation

enum Language: String, CaseIterable {
    case portuguese = "pt-BR"
    case english = "en"

    var displayName: String {
        switch self {
        case .portuguese:
            return "Português (Brasil)"
        case .english:
            return "English"
        }
    }

    static var systemDefault: Language {
        let preferred = Locale.preferredLanguages.first ?? ""
        return preferred.hasPrefix("pt") ? .portuguese : .english
    }
}

struct Strings {
    let turnOn: String
    let turnOff: String
    let settings: String
    let quit: String
    let tooltipActive: String
    let tooltipInactive: String
    let settingsTitle: String
    let launchAtLogin: String
    let restoreState: String
    let hideWhenInControlCenter: String
    let language: String

    static func of(_ language: Language) -> Strings {
        switch language {
        case .portuguese:
            return Strings(
                turnOn: "Ligar",
                turnOff: "Desligar",
                settings: "Configurações…",
                quit: "Sair",
                tooltipActive: "Tela sempre ligada",
                tooltipInactive: "Comportamento normal",
                settingsTitle: "Configurações",
                launchAtLogin: "Abrir automaticamente no login",
                restoreState: "Manter o último estado ao reiniciar",
                hideWhenInControlCenter: "Esconder da barra quando estiver na Central de Controle",
                language: "Idioma:"
            )
        case .english:
            return Strings(
                turnOn: "Turn On",
                turnOff: "Turn Off",
                settings: "Settings…",
                quit: "Quit",
                tooltipActive: "Display always on",
                tooltipInactive: "Normal behavior",
                settingsTitle: "Settings",
                launchAtLogin: "Launch at login",
                restoreState: "Keep last state after restart",
                hideWhenInControlCenter: "Hide from menu bar when added to Control Center",
                language: "Language:"
            )
        }
    }
}
