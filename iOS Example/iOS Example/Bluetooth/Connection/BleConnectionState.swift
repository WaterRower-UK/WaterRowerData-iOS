import Foundation

enum BleConnectionState {

    case disconnected
    case connecting
    case connected(device: ConnectedBleDevice)
    case failed
}
