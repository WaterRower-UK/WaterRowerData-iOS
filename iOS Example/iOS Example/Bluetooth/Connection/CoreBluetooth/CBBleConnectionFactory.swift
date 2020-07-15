import Foundation
import CoreBluetooth

/**
 A factory class for creating CBBleConnection instances.

 This class is not thread safe.
 */
class CBBleConnectionFactory {

    static let instance = CBBleConnectionFactory()

    private init() {}

    private var connections = [UUID: CBBleConnection]()

    func create(from peripheral: CBPeripheral) -> CBBleConnection {
        return create(from: peripheral.identifier)
    }

    func create(from identifier: UUID) -> CBBleConnection {
        if let connection = connections[identifier] {
            return connection
        }

        let connection = CBBleConnection(identifier: identifier)
        connections[identifier] = connection
        return connection
    }
}
