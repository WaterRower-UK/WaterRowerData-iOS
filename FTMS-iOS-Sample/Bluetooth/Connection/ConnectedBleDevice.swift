import Foundation

/**
 A protocol that represents an established connection with a BLE device.
 */
protocol ConnectedBleDevice {

    func read(
        serviceUUID: UUID,
        characteristicUUID: UUID,
        callback: @escaping (Data) -> Void
    ) -> Cancellable

    func listen(
        serviceUUID: UUID,
        characteristicUUID: UUID,
        callback: @escaping (Data) -> Void
    ) -> Cancellable
}
