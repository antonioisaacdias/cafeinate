import AppKit

final class SettingsWindowController: NSWindowController {
    private let preferences: Preferences
    private let launchAtLoginBox = NSButton(checkboxWithTitle: "Abrir automaticamente no login", target: nil, action: nil)
    private let restoreStateBox = NSButton(checkboxWithTitle: "Manter o último estado ao reiniciar", target: nil, action: nil)

    init(preferences: Preferences) {
        self.preferences = preferences

        let window = NSWindow(contentRect: .zero, styleMask: [.titled, .closable], backing: .buffered, defer: false)
        window.title = "Configurações"
        window.isReleasedWhenClosed = false
        super.init(window: window)

        launchAtLoginBox.target = self
        launchAtLoginBox.action = #selector(launchAtLoginChanged)
        restoreStateBox.target = self
        restoreStateBox.action = #selector(restoreStateChanged)

        window.contentView = buildContent()
        window.setContentSize(window.contentView!.fittingSize)
        window.center()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func present() {
        syncCheckboxes()
        NSApp.activate(ignoringOtherApps: true)
        showWindow(nil)
        window?.makeKeyAndOrderFront(nil)
    }

    private func buildContent() -> NSView {
        let stack = NSStackView(views: [launchAtLoginBox, restoreStateBox])
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
        return container
    }

    private func syncCheckboxes() {
        launchAtLoginBox.state = preferences.launchAtLogin ? .on : .off
        restoreStateBox.state = preferences.restoreState ? .on : .off
    }

    @objc private func launchAtLoginChanged() {
        preferences.setLaunchAtLogin(launchAtLoginBox.state == .on)
        syncCheckboxes()
    }

    @objc private func restoreStateChanged() {
        preferences.restoreState = restoreStateBox.state == .on
    }
}
