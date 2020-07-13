import Foundation
import CoreBluetooth

struct ScanResult {

    let peripheral: CBPeripheral
    let advertisementData: [String: Any]
    let rssi: NSNumber
}
