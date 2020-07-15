import Foundation
import CoreBluetooth

protocol BleScanner {

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
                A strong reference must be held to this instance,
                disposing of the reference cancels the scan.
     */
    func startScan(
        withServices scanServicesUUIDs: [CBUUID]?,
        allowDuplicates: Bool,
        _ callback: BleScanCallback
    ) -> Cancellable
}

extension BleScanner {

    func startScan(
        withServices scanServicesUUIDs: [CBUUID]? = nil,
        allowDuplicates: Bool = false,
        _ callback: BleScanCallback
    ) -> Cancellable {
        return startScan(
            withServices: scanServicesUUIDs,
            allowDuplicates: allowDuplicates,
            callback
        )
    }

    func startScan(
        withServices scanServicesUUIDs: [CBUUID]? = nil,
        allowDuplicates: Bool = false,
        _ callback: @escaping (ScanResult) -> Void
    ) -> Cancellable {
        return startScan(
            withServices: scanServicesUUIDs,
            allowDuplicates: allowDuplicates,
            ClosureBleScanCallback(closure: callback)
        )
    }
}

private struct ClosureBleScanCallback: BleScanCallback {

    let closure: (ScanResult) -> Void

    func onScanResult(_ scanResult: ScanResult) {
        closure(scanResult)
    }
}
