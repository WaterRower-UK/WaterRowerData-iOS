import Foundation

protocol CBConnectionStateListener: NSObjectProtocol {

    /** Invoked when the connection state has changed. */
    func onConnectionStateChanged(_ connectionState: CBConnectionState)
}

/**
 A convenience function to construct CBConnectionStateListeners using a closure.
 */
func connectionStateListener(_ closure: @escaping (CBConnectionState) -> Void) -> CBConnectionStateListener {
    return ClosureCBBleConnectionStateListener(closure)
}

private class ClosureCBBleConnectionStateListener: NSObject, CBConnectionStateListener {

    private let closure: (CBConnectionState) -> Void

    init(_ closure: @escaping (CBConnectionState) -> Void) {
        self.closure = closure
    }

    func onConnectionStateChanged(_ connectionState: CBConnectionState) {
        closure(connectionState)
    }
}
