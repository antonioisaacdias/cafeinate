import Foundation
import notify

enum ControlChannel {
    static let controlKind = "local.widget-cafeinate.toggle"
    static let turnOnRequest = "local.widget-cafeinate.request.on"
    static let turnOffRequest = "local.widget-cafeinate.request.off"
    static let stateName = "local.widget-cafeinate.state"

    static func post(_ name: String) {
        notify_post(name)
    }

    static func readState() -> Bool {
        var token: Int32 = 0
        if notify_register_check(stateName, &token) != NOTIFY_STATUS_OK {
            return false
        }
        var state: UInt64 = 0
        notify_get_state(token, &state)
        notify_cancel(token)
        return state == 1
    }
}
