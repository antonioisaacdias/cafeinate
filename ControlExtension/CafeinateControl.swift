import AppIntents
import SwiftUI
import WidgetKit

@main
struct CafeinateControlBundle: WidgetBundle {
    var body: some Widget {
        CafeinateControl()
    }
}

struct CafeinateControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: ControlChannel.controlKind, provider: Provider()) { isActive in
            ControlWidgetToggle("Cafeinate", isOn: isActive, action: SetAwakeIntent()) { on in
                Label(on ? "On" : "Off", systemImage: on ? "cup.and.saucer.fill" : "cup.and.saucer")
            }
            .tint(.white)
        }
        .displayName("Cafeinate")
        .description("Keep the display awake")
    }

    struct Provider: ControlValueProvider {
        var previewValue: Bool { false }

        func currentValue() async throws -> Bool {
            ControlChannel.readState()
        }
    }
}

struct SetAwakeIntent: SetValueIntent {
    static let title: LocalizedStringResource = "Keep display awake"

    @Parameter(title: "Awake")
    var value: Bool

    func perform() async throws -> some IntentResult {
        ControlChannel.post(value ? ControlChannel.turnOnRequest : ControlChannel.turnOffRequest)
        return .result()
    }
}
