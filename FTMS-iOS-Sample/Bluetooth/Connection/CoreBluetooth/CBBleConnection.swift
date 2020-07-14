import Foundation
import CoreBluetooth
import os
import FTMS_iOS_Framework

private let log = OSLog(subsystem: "uk.co.waterrower.bluetooth.plist", category: "CBBleConnection")

class CBBleConnection: BleConnection {

    private let peripheralIdentifier: UUID

    private var connectionState: BleConnectionState = .Disconnected {
        didSet {
            listeners.forEach { listener in listener.onConnectionStateChanged(connectionState) }
        }
    }

    private var listeners: [BleConnectionStateListener] = []

    init(
        from peripheral: CBPeripheral
    ) {
        self.peripheralIdentifier = peripheral.identifier
    }

    private var manager: CBCentralManager?

    // swiftlint:disable weak_delegate
    private var delegate: BLEConnectionDelegate?

    func connect() {
        delegate = BLEConnectionDelegate(peripheralIdentifier, self)
        manager = CBCentralManager(delegate: delegate, queue: nil)
    }

    func disconnect() {
        os_log("Disconnecting %@", log: log, type: .info, peripheralIdentifier.uuidString)
        guard let manager = manager else {
            return
        }

        self.delegate?.disconnect(manager)
    }

    func addConnectionStateListener(listener: BleConnectionStateListener) -> Cancellable {
        listeners.append(listener)
        return CancelListening(self, listener)
    }

    private class BLEConnectionDelegate: NSObject, CBCentralManagerDelegate {

        private unowned let parent: CBBleConnection
        private let peripheralIdentifier: UUID

        // swiftlint:disable weak_delegate
        private let peripheralDelegate: CBPeripheralDelegate

        init(
            _ peripheralIdentifier: UUID,
            _ parent: CBBleConnection
        ) {
            self.parent = parent
            self.peripheralIdentifier = peripheralIdentifier
            peripheralDelegate = BleConnectionPeripheralDelegate(parent)
        }

        private var peripheral: CBPeripheral?

        func disconnect(_ manager: CBCentralManager) {
            guard let peripheral = peripheral else {
                os_log("Cannot disconnect not connected peripheral", log: log, type: .error)
                return
            }

            manager.cancelPeripheralConnection(peripheral)
        }

        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            os_log("centralManagerDidUpdateState %d", log: log, type: .debug, central.state.rawValue)

            guard peripheral == nil else {
                os_log("Already connected", log: log, type: .debug)
                return
            }

            guard central.state == .poweredOn else {
                os_log("Invalid state, not connecting: %d", log: log, type: .error, central.state.rawValue)
                parent.connectionState = .Failed
                return
            }

            guard let peripheral = central.retrievePeripherals(withIdentifiers: [peripheralIdentifier]).first else {
                os_log("Could not find peripheral with id %@", log: log, type: .error, peripheralIdentifier.uuidString)
                parent.connectionState = .Failed
                return
            }

            os_log("Connecting to %@", log: log, type: .info, peripheral)
            self.peripheral = peripheral
            parent.connectionState = .Connecting
            central.connect(peripheral, options: nil)
        }

        private var isDiscoveringServices = false

        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            os_log("didConnect %@", log: log, type: .debug, peripheral)
            if isDiscoveringServices {
                os_log("Already discovering services")
                return
            }

            isDiscoveringServices = true
            peripheral.delegate = peripheralDelegate
            peripheral.discoverServices(nil)
        }

        func centralManager(
            _ central: CBCentralManager,
            didDisconnectPeripheral peripheral: CBPeripheral,
            error: Error?
        ) {
            os_log("didDisconnectPeripheral %@", log: log, type: .debug, peripheral)
            parent.delegate = nil
            parent.manager = nil
        }
    }

    private class BleConnectionPeripheralDelegate: NSObject, CBPeripheralDelegate {

        private unowned let parent: CBBleConnection

        init(
            _ parent: CBBleConnection
        ) {
            self.parent = parent
        }

        private var pendingServices: [CBService] = []

        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            if let error = error {
                os_log(
                    "An error occurred while discovering services: %@",
                    log: log,
                    type: .error,
                    String(describing: error)
                )
                parent.connectionState = .Failed
                return
            }

            os_log("peripheral didDiscoverServices %@", log: log, type: .debug, peripheral.services!)
            guard let services = peripheral.services else {
                os_log("Device has no services", log: log, type: .error)
                parent.connectionState = .Failed
                return
            }

            pendingServices = services
            continueDiscovering(peripheral)
        }

        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            if let error = error {
                os_log(
                    "An error occurred while discovering characteristics: %@",
                    log: log,
                    type: .error,
                    String(describing: error)
                )
                parent.connectionState = .Failed
                return
            }

            os_log(
                "peripheral didDiscoverCharacteristicsFor %@(%@): %@",
                log: log,
                type: .debug,
                service,
                service.uuid.uuidString,
                service.characteristics!
            )
            continueDiscovering(peripheral)
        }

        private func continueDiscovering(_ peripheral: CBPeripheral) {
            guard let service = pendingServices.first else {
                os_log("Done discovering services and characteristics", log: log, type: .debug)
                parent.connectionState = .Connected(device: CBConnectedBleDevice(from: peripheral))
                return
            }

            pendingServices.removeAll { s -> Bool in
                s === service
            }
            os_log("Discovering characteristics for %@(%@)", log: log, type: .debug, service, service.uuid.uuidString)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    private class CancelListening: Cancellable {

        private unowned let parent: CBBleConnection
        private let listener: BleConnectionStateListener

        init(
            _ parent: CBBleConnection,
            _ listener: BleConnectionStateListener
        ) {
            self.parent = parent
            self.listener = listener
        }

        func cancel() {
            parent.listeners.removeAll { l in l === listener }
        }

        deinit {
            cancel()
        }
    }
}
