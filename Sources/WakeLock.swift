import IOKit.pwr_mgt

final class WakeLock {
    private var assertionID: IOPMAssertionID = 0
    private(set) var isActive = false

    func setActive(_ active: Bool) {
        if active == isActive {
            return
        }
        if active {
            let result = IOPMAssertionCreateWithName(
                kIOPMAssertionTypePreventUserIdleDisplaySleep as CFString,
                IOPMAssertionLevel(kIOPMAssertionLevelOn),
                "Cafeinate" as CFString,
                &assertionID
            )
            isActive = result == kIOReturnSuccess
        } else {
            IOPMAssertionRelease(assertionID)
            isActive = false
        }
    }
}
