import os
import CoreBluetooth
import Foundation

private let log = OSLog(subsystem: "uk.co.waterrower.bluetooth.plist", category: "CBBleScanner")

/**
 A class that helps with scanning for BLE devices.
 
 This class instantiates a new `CBCentralManager` for each scan request,
 allowing the implementation to keep the scan results separate.
 */
class CBScanner {

    /** Strong references to the active managers */
    private var managers: [CBCentralManager] = []

    /** Strong references to the active delegates */
    private var delegates: [CBCentralManagerDelegate] = []

    /**
     Starts a scan for peripherals that are advertising.
     
     - Parameter withServices: An array of CBUUID objects that the app is
       interested in. Each CBUUID object represents the UUID of a service
       that a peripheral advertises.
     
     - Parameter allowDuplicates: If `true`, filtering is disabled and a
       discovery event is generated each time an advertising packet is
       received from the peripheral. If `false`, multiple discoveries of
       the same peripheral are grouped in a single event.
     
     - Returns: A `Cancellable` that can be used to cancel the scan.
       A strong reference must be held to this instance, disposing of
       the reference cancels the scan.
     */
    func startScan(
        withServices scanServicesUUIDs: [CBUUID]?,
        allowDuplicates: Bool = false,
        _ callback: @escaping (CBScanResult) -> Void
    ) -> Cancellable {
        let delegate = BLEScanDelegate(withServices: scanServicesUUIDs, allowDuplicates: allowDuplicates, callback)
        let manager = CBCentralManager(delegate: delegate, queue: nil)

        managers.append(manager)
        delegates.append(delegate)

        return BLEScanCanceller(self, manager, delegate)
    }

    private class BLEScanDelegate: NSObject, CBCentralManagerDelegate {

        private let scanServiceUUIDs: [CBUUID]?
        private let allowDuplicates: Bool
        private let callback: (CBScanResult) -> Void

        init(
            withServices scanServiceUUIDs: [CBUUID]?,
            allowDuplicates: Bool,
            _ callback: @escaping (CBScanResult) -> Void
        ) {
            self.scanServiceUUIDs = scanServiceUUIDs
            self.allowDuplicates = allowDuplicates
            self.callback = callback
        }

        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            os_log("centralManagerDidUpdateState %d", log: log, type: .debug, central.state.rawValue)

            guard central.state == .poweredOn else {
                os_log("Invalid state, not scanning: %d", log: log, type: .error, central.state.rawValue)
                return
            }

            if scanServiceUUIDs == nil {
                os_log("Start scanning for peripherals without filters", log: log, type: .debug)
            } else {
                os_log(
                    "Start scanning for peripherals: %@",
                    log: log,
                    type: .debug,
                    scanServiceUUIDs!
                )
            }

            let options = [CBCentralManagerScanOptionAllowDuplicatesKey: allowDuplicates]
            central.scanForPeripherals(
                withServices: scanServiceUUIDs,
                options: options
            )
        }

        func centralManager(
            _ central: CBCentralManager,
            didDiscover peripheral: CBPeripheral,
            advertisementData: [String: Any],
            rssi RSSI: NSNumber
        ) {
            // os_log("centralManagerDidDiscover %@", log: log, type: .debug, "\(peripheral)")

            callback(
                CBScanResult(
                    peripheral: peripheral,
                    advertisementData: advertisementData,
                    rssi: RSSI
                )
            )
        }
    }

    private class BLEScanCanceller: Cancellable {

        private unowned let scanner: CBScanner

        // swiftlint:disable weak_delegate
        private let delegate: CBCentralManagerDelegate
        private let manager: CBCentralManager

        init(
            _ scanner: CBScanner,
            _ manager: CBCentralManager,
            _ delegate: CBCentralManagerDelegate

        ) {
            self.scanner = scanner
            self.manager = manager
            self.delegate = delegate
        }

        func cancel() {
            os_log("Cancelling scan", log: log, type: .debug)
            scanner.managers.removeAll { m in m === manager }
            scanner.delegates.removeAll { d in d === delegate }

            if manager.state == .poweredOn {
                manager.stopScan()
            }
        }

        deinit {
            cancel()
        }
    }
}
