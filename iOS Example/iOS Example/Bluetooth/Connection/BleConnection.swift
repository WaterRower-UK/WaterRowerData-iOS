import Foundation
import CoreBluetooth

/**
 Represents a connection to a BLE device.

 A connection can be made using `connect()`, use the `BleConnectionStateListener`
 to eventually receive a `ConnectedBleDevice`.
 */
protocol BleConnection {

    /**
     Tries to establish a connection with the BLE device.

     Listeners registered with `addConnectionStateListener` will be invoked
     with connection status updates.
     */
    func connect()

    /**
     Closes the connection with the BLE device.
     */
    func disconnect()

    /**
     Registers given listener to receive connection state changes.

     The listener will immediately be notified of the current connection state.

     - Returns: A Cancellable that can be invoked to stop listening.
                A strong reference must be held to this instance,
                disposing of the reference cancels the listener.
     */
    func addConnectionStateListener(listener: BleConnectionStateListener) -> Cancellable
}

extension BleConnection {

    func addConnectionStateListener(listener: @escaping (BleConnectionState) -> Void) -> Cancellable {
        return addConnectionStateListener(listener: ClosureBleConnectionStateListener(listener))
    }
}

private class ClosureBleConnectionStateListener: NSObject, BleConnectionStateListener {

    private let closure: (BleConnectionState) -> Void

    init(_ closure: @escaping (BleConnectionState) -> Void) {
        self.closure = closure
    }

    func onConnectionStateChanged(_ connectionState: BleConnectionState) {
        self.closure(connectionState)
    }
}
