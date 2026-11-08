import Foundation
import notify
import WidgetKit

final class ControlCenterBridge {
    private var tokens: [Int32] = []
    private var stateToken: Int32 = 0

    init(onRequest: @escaping (Bool) -> Void) {
        notify_register_check(ControlChannel.stateName, &stateToken)
        listen(ControlChannel.turnOnRequest) { onRequest(true) }
        listen(ControlChannel.turnOffRequest) { onRequest(false) }
    }

    deinit {
        tokens.forEach { notify_cancel($0) }
        notify_cancel(stateToken)
    }

    func publish(_ active: Bool) {
        notify_set_state(stateToken, active ? 1 : 0)
        if #available(macOS 26.0, *) {
            ControlCenter.shared.reloadControls(ofKind: ControlChannel.controlKind)
        }
    }

    private func listen(_ name: String, handler: @escaping () -> Void) {
        var token: Int32 = 0
        let status = notify_register_dispatch(name, &token, .main) { _ in
            handler()
        }
        if status == NOTIFY_STATUS_OK {
            tokens.append(token)
        }
    }
}
