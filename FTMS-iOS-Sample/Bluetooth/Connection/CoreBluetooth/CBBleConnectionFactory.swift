import Foundation
import CoreBluetooth

/**
 A factory class for creating CBBleConnection instances.
 */
class CBBleConnectionFactory {

    static let instance = CBBleConnectionFactory()

    private init() {}

    func create(from peripheral: CBPeripheral) -> CBBleConnection {
        return CBBleConnection(from: peripheral)
    }
}
