import Foundation

protocol BleConnectionStateListener: NSObjectProtocol {

    /** Invoked when the connection state has changed. */
    func onConnectionStateChanged(_ connectionState: BleConnectionState)
}
