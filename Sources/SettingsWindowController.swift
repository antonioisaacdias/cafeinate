import AppKit

final class SettingsWindowController: NSWindowController {
    private let preferences: Preferences
    private let onLanguageChange: () -> Void
    private let onIconVisibilityChange: () -> Void
    private let launchAtLoginBox = NSButton(checkboxWithTitle: "", target: nil, action: nil)
    private let restoreStateBox = NSButton(checkboxWithTitle: "", target: nil, action: nil)
    private let hideInControlCenterBox = NSButton(checkboxWithTitle: "", target: nil, action: nil)
    private let languageLabel = NSTextField(labelWithString: "")
    private let languagePopup = NSPopUpButton()

    init(preferences: Preferences, onLanguageChange: @escaping () -> Void, onIconVisibilityChange: @escaping () -> Void) {
        self.preferences = preferences
        self.onLanguageChange = onLanguageChange
        self.onIconVisibilityChange = onIconVisibilityChange

        let window = NSWindow(contentRect: .zero, styleMask: [.titled, .closable], backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        super.init(window: window)

        launchAtLoginBox.target = self
        launchAtLoginBox.action = #selector(launchAtLoginChanged)
        restoreStateBox.target = self
        restoreStateBox.action = #selector(restoreStateChanged)
        hideInControlCenterBox.target = self
        hideInControlCenterBox.action = #selector(hideInControlCenterChanged)
        languagePopup.addItems(withTitles: Language.allCases.map(\.displayName))
        languagePopup.target = self
        languagePopup.action = #selector(languageChanged)

        window.contentView = buildContent()
        applyStrings()
        window.center()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func present() {
        syncControls()
        NSApp.activate(ignoringOtherApps: true)
        showWindow(nil)
        window?.makeKeyAndOrderFront(nil)
    }

    private func buildContent() -> NSView {
        let languageRow = NSStackView(views: [languageLabel, languagePopup])
        languageRow.orientation = .horizontal
        languageRow.spacing = 8

        var checkboxes = [launchAtLoginBox, restoreStateBox]
        if #available(macOS 26.0, *) {
            checkboxes.append(hideInControlCenterBox)
        }
        let stack = NSStackView(views: checkboxes + [languageRow])
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 12
        stack.setCustomSpacing(18, after: checkboxes[checkboxes.count - 1])
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

    private func applyStrings() {
        let strings = preferences.strings
        window?.title = strings.settingsTitle
        launchAtLoginBox.title = strings.launchAtLogin
        restoreStateBox.title = strings.restoreState
        hideInControlCenterBox.title = strings.hideWhenInControlCenter
        languageLabel.stringValue = strings.language
        if let content = window?.contentView {
            window?.setContentSize(content.fittingSize)
        }
    }

    private func syncControls() {
        launchAtLoginBox.state = preferences.launchAtLogin ? .on : .off
        restoreStateBox.state = preferences.restoreState ? .on : .off
        hideInControlCenterBox.state = preferences.hideWhenInControlCenter ? .on : .off
        languagePopup.selectItem(at: Language.allCases.firstIndex(of: preferences.language) ?? 0)
    }

    @objc private func launchAtLoginChanged() {
        preferences.setLaunchAtLogin(launchAtLoginBox.state == .on)
        syncControls()
    }

    @objc private func restoreStateChanged() {
        preferences.restoreState = restoreStateBox.state == .on
    }

    @objc private func hideInControlCenterChanged() {
        preferences.hideWhenInControlCenter = hideInControlCenterBox.state == .on
        onIconVisibilityChange()
    }

    @objc private func languageChanged() {
        preferences.language = Language.allCases[languagePopup.indexOfSelectedItem]
        applyStrings()
        onLanguageChange()
    }
}
