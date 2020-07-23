import Foundation
import CoreBluetooth
import os

private let log = OSLog(subsystem: "uk.co.waterrower.bluetooth.plist", category: "CBConnectedBleDevice")

/**
 Represents a connected BLE device.
 
 Use `CBConnection` to obtain an instance of this class.
 */
class CBConnectedDevice: NSObject, CBPeripheralDelegate {

    private let peripheral: CBPeripheral

    /**
     - Parameter from: A `CBPeripheral` that is connected.
     */
    init(
        from peripheral: CBPeripheral
    ) {
        self.peripheral = peripheral
        super.init()
        peripheral.delegate = self
    }

    private var callbacks: [CBUUID: [ListenCallback]] = [:]

    /**
     Enables characteristic notifications for given `serviceUUID` and
     `characteristicUUID` and invokes `callback` when notifications arrive.
     
     For simplicity for this sample app, this function does not disable the
     characteristic notifications when invoking the resulting cancellable.
     
     - Returns: A `Cancellable` that can be used to stop receiving notifications.
                A strong reference must be held to this instance,
                disposing of the reference cancels the listener.
     */
    func listen(
        serviceUUID: UUID,
        characteristicUUID: UUID,
        callback: @escaping (Data) -> Void
    ) -> Cancellable {
        guard let services: [CBService] = peripheral.services else {
            fatalError("Peripheral has no services")
        }

        guard let service = services.first(where: { service in
            service.uuid == CBUUID(nsuuid: serviceUUID)
        }) else {
            fatalError("Service doesn't exist for UUID: \(serviceUUID)")
        }

        guard let characteristic = service.characteristics?.first(where: { characteristic in
            characteristic.uuid == CBUUID(nsuuid: characteristicUUID)
        }) else {
            fatalError("Characteristic doesn't exist for UUID: \(characteristicUUID)")
        }

        let characteristicCBUUID = CBUUID(nsuuid: characteristicUUID)

        var callbackList: [ListenCallback]? = callbacks[characteristicCBUUID]
        if callbackList == nil {
            callbackList = []
        }
        let callback = ListenCallback(callback)
        callbackList!.append(callback)
        callbacks[characteristicCBUUID] = callbackList

        os_log("Set notify value true for %@", log: log, type: .debug, characteristic)
        peripheral.setNotifyValue(true, for: characteristic)
        peripheral.writeValue(
            Data(),
            for: characteristic,
            type: CBCharacteristicWriteType.withResponse
        )

        return CancelListening(
            self,
            characteristicCBUUID,
            callback
        )
    }

    private class ListenCallback {

        let closure: (Data) -> Void

        init(_ closure: @escaping (Data) -> Void) {
            self.closure = closure
        }
    }

    private class CancelListening: Cancellable {

        private weak var owner: CBConnectedDevice?
        private let uuid: CBUUID
        private let callback: ListenCallback

        init(
            _ owner: CBConnectedDevice,
            _ uuid: CBUUID,
            _ callback: ListenCallback
        ) {
            self.owner = owner
            self.uuid = uuid
            self.callback = callback
        }

        func cancel() {
            os_log("Removing callback for %@", log: log, type: .debug, uuid)
            owner?.callbacks[uuid]?.removeAll(where: { c -> Bool in
                c === callback
            })
        }

        deinit {
            cancel()
        }
    }

    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        callbacks[characteristic.uuid]?.forEach { callback in
            if let data = characteristic.value {
                callback.closure(data)
            }
        }
    }
}
