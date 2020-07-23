import Foundation

enum CBConnectionState {

    case disconnected
    case connecting
    case connected(device: CBConnectedDevice)
    case failed
}
