import Foundation
import CoreBluetooth
import os
import WaterRowerData_iOS

private let log = OSLog(subsystem: "uk.co.waterrower.bluetooth.plist", category: "CBBleConnection")

class CBBleConnection: BleConnection {

    private let peripheralIdentifier: UUID

    private var connectionState: BleConnectionState = .disconnected {
        didSet {
            listeners.forEach { listener in listener.onConnectionStateChanged(connectionState) }
        }
    }

    private var listeners: [BleConnectionStateListener] = []

    init(
        identifier: UUID
    ) {
        self.peripheralIdentifier = identifier
    }

    init(
        from peripheral: CBPeripheral
    ) {
        self.peripheralIdentifier = peripheral.identifier
    }

    // swiftlint:disable weak_delegate
    private var delegate: BLEConnectionDelegate?
    private var manager: CBCentralManager?

    func connect() {
        // Set up the CBCentralManager to initiate the connection
        delegate = BLEConnectionDelegate(peripheralIdentifier, self)
        manager = CBCentralManager(delegate: delegate, queue: nil)
    }

    func disconnect() {
        guard let manager = manager else {
            os_log("Connection not connected, not disconnecting", log: log, type: .debug)
            return
        }

        os_log("Disconnecting %@", log: log, type: .info, peripheralIdentifier.uuidString)
        self.delegate?.disconnect(manager)
    }

    func addConnectionStateListener(listener: BleConnectionStateListener) -> Cancellable {
        listeners.append(listener)
        listener.onConnectionStateChanged(connectionState)
        return CancelListening(self, listener)
    }

    /**
     A `CBCentralManagerDelegate` which initiates a connection with the peripheral when the
     `CBCentralManager` is ready.
     */
    private class BLEConnectionDelegate: NSObject, CBCentralManagerDelegate {

        private unowned let parent: CBBleConnection
        private let peripheralIdentifier: UUID

        // swiftlint:disable weak_delegate
        private let peripheralDelegate: BleConnectionPeripheralDelegate

        init(
            _ peripheralIdentifier: UUID,
            _ parent: CBBleConnection
        ) {
            self.parent = parent
            self.peripheralIdentifier = peripheralIdentifier
            peripheralDelegate = BleConnectionPeripheralDelegate(parent)
        }

        /**
         The peripheral that is connected or being connected to.
         If the connection isn't set up yet or is disconnected, this value is nil.
         */
        private var peripheral: CBPeripheral?

        /**
         Whether the connection was cancelled, by invoking `disconnect()`.
         */
        private var connectionCancelled = false {
            didSet { peripheralDelegate.connectionCancelled = connectionCancelled }
        }

        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            os_log("centralManagerDidUpdateState %d", log: log, type: .debug, central.state.rawValue)

            guard peripheral == nil else {
                os_log("Already connected", log: log, type: .debug)
                return
            }

            if connectionCancelled {
                os_log("Connection cancelled", log: log, type: .debug)
                return
            }

            guard central.state == .poweredOn else {
                os_log("Invalid state, not connecting: %d", log: log, type: .error, central.state.rawValue)
                parent.connectionState = .failed
                return
            }

            guard let peripheral = central.retrievePeripherals(withIdentifiers: [peripheralIdentifier]).first else {
                os_log("Could not find peripheral with id %@", log: log, type: .error, peripheralIdentifier.uuidString)
                parent.connectionState = .failed
                return
            }

            os_log("Connecting to %@", log: log, type: .info, peripheral)
            self.peripheral = peripheral
            parent.connectionState = .connecting
            central.connect(peripheral, options: nil)
        }

        private var isDiscoveringServices = false

        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            if connectionCancelled {
                os_log("Manager did connect to peripheral, but connection was cancelled", log: log, type: .error)
                central.cancelPeripheralConnection(peripheral)
                return
            }

            if self.peripheral != peripheral {
                os_log("Manager did connect to different peripheral, disconnecting", log: log, type: .error)
                central.cancelPeripheralConnection(peripheral)
                return
            }

            os_log("centralManager didConnect %@", log: log, type: .debug, peripheral)
            if isDiscoveringServices {
                os_log("Already discovering services")
                return
            }

            os_log("Discovering services", log: log, type: .debug)
            isDiscoveringServices = true
            peripheral.delegate = peripheralDelegate
            peripheral.discoverServices(nil)
        }

        func centralManager(
            _ central: CBCentralManager,
            didDisconnectPeripheral peripheral: CBPeripheral,
            error: Error?
        ) {
            os_log("centralManager didDisconnectPeripheral %@", log: log, type: .debug, peripheral)
            if self.peripheral != peripheral {
                os_log("Disconnected peripheral differs from wanted peripheral")
                return
            }

            parent.delegate = nil
            parent.manager = nil
            parent.connectionState = .disconnected
        }

        func disconnect(_ manager: CBCentralManager) {
            guard let peripheral = peripheral else {
                os_log("Peripheral connection not yet initiated, cancelling", log: log, type: .error)
                connectionCancelled = true

                parent.delegate = nil
                parent.manager = nil
                return
            }

            manager.cancelPeripheralConnection(peripheral)
            connectionCancelled = true
        }
    }

    /**
     A `CBPeripheralDelegate` which sets up the connection with the peripheral once initiated.
     */
    private class BleConnectionPeripheralDelegate: NSObject, CBPeripheralDelegate {

        private unowned let parent: CBBleConnection
        var connectionCancelled = false

        init(
            _ parent: CBBleConnection
        ) {
            self.parent = parent
        }

        private var pendingServices: [CBService] = []

        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            if connectionCancelled {
                os_log("Peripheral did discover services but connection was cancelled.", log: log, type: .debug)
                return
            }

            if let error = error {
                os_log(
                    "An error occurred while discovering services: %@",
                    log: log,
                    type: .error,
                    String(describing: error)
                )
                parent.connectionState = .failed
                return
            }

            os_log("peripheral didDiscoverServices %@", log: log, type: .debug, peripheral.services!)
            guard let services = peripheral.services else {
                os_log("Device has no services", log: log, type: .error)
                parent.connectionState = .failed
                return
            }

            pendingServices = services
            continueDiscovering(peripheral)
        }

        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            if connectionCancelled {
                os_log("Peripheral did discover characteristics but connection was cancelled", log: log, type: .debug)
                return
            }

            if let error = error {
                os_log(
                    "An error occurred while discovering characteristics: %@",
                    log: log,
                    type: .error,
                    String(describing: error)
                )
                parent.connectionState = .failed
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
                parent.connectionState = .connected(device: CBConnectedBleDevice(from: peripheral))
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

        private weak var parent: CBBleConnection?
        private let listener: BleConnectionStateListener

        init(
            _ parent: CBBleConnection,
            _ listener: BleConnectionStateListener
        ) {
            self.parent = parent
            self.listener = listener
        }

        func cancel() {
            parent?.listeners.removeAll { l in l === listener }
        }

        deinit {
            cancel()
        }
    }
}
