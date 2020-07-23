import Foundation
import CoreBluetooth

struct CBScanResult {

    let peripheral: CBPeripheral
    let advertisementData: [String: Any]
    let rssi: NSNumber
}
