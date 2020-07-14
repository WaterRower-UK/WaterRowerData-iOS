import Foundation
import CoreBluetooth
import FTMS_iOS_Framework

class ConnectedRowerDataBleDevice {

    private let connectedBleDevice: ConnectedBleDevice

    init(from device: ConnectedBleDevice) {
        self.connectedBleDevice = device
    }

    func rowerData(callback: @escaping (RowerData) -> Void) -> Cancellable {
        return connectedBleDevice.listen(
            serviceUUID: FitnessMachineService.uuid,
            characteristicUUID: RowerDataCharacteristic.uuid
        ) { data in
            callback(RowerDataCharacteristic.decode(data: data))
        }
    }
}
