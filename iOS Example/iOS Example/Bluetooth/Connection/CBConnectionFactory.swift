import Foundation
import CoreBluetooth

/**
 A factory class for creating CBConnection instances.

 This class is not thread safe.
 */
class CBConnectionFactory {

    static let instance = CBConnectionFactory()

    private init() {}

    private var connections = [UUID: CBConnection]()

    func create(from peripheral: CBPeripheral) -> CBConnection {
        return create(from: peripheral.identifier)
    }

    func create(from identifier: UUID) -> CBConnection {
        if let connection = connections[identifier] {
            return connection
        }

        let connection = CBConnection(identifier: identifier)
        connections[identifier] = connection
        return connection
    }
}
