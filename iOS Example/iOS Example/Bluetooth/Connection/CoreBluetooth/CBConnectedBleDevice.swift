import Foundation
import CoreBluetooth
import os

private let log = OSLog(subsystem: "uk.co.waterrower.bluetooth.plist", category: "CBConnectedBleDevice")

class CBConnectedBleDevice: NSObject, ConnectedBleDevice, CBPeripheralDelegate {

    private let peripheral: CBPeripheral

    init(
        from peripheral: CBPeripheral
    ) {
        self.peripheral = peripheral
        super.init()
        peripheral.delegate = self
    }

    func read(
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
            fatalError("Characteristic does not exist for UUID: \(characteristicUUID)")
        }

        var callbacks: [(Data) -> Void]? = listeners[CBUUID(nsuuid: characteristicUUID)]
        if callbacks == nil {
            callbacks = []
        }
        callbacks!.append(callback)
        listeners[CBUUID(nsuuid: characteristicUUID)] = callbacks

        peripheral.readValue(for: characteristic)

        class CancelRead: Cancellable {

            func cancel() {
                // TODO: Implement cancellation
            }
        }

        return CancelRead()
    }

    private var listeners: [CBUUID: [(Data) -> Void]] = [:]

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

        var callbacks: [(Data) -> Void]? = listeners[CBUUID(nsuuid: characteristicUUID)]
        if callbacks == nil {
            callbacks = []
        }
        callbacks!.append(callback)
        listeners[CBUUID(nsuuid: characteristicUUID)] = callbacks

        os_log("Set notify value true for %@", log: log, type: .debug, characteristic)
        peripheral.setNotifyValue(true, for: characteristic)
        peripheral.writeValue(
            Data(),
            for: characteristic,
            type: CBCharacteristicWriteType.withResponse
        )

        return CancelListening()
    }

    private class CancelListening: Cancellable {

        func cancel() {
            // TODO: Implement cancellation
        }
    }

    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        listeners[characteristic.uuid]?.forEach { listener in
            if let data = characteristic.value {
                listener(data)
            }
        }
    }
}
