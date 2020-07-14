import Foundation

enum BleConnectionState {

    case Disconnected
    case Connecting
    case Connected(device: ConnectedBleDevice)
    case Failed
}
