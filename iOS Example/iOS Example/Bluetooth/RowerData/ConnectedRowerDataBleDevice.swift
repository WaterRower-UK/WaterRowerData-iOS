import Foundation
import CoreBluetooth
import WaterRowerData_iOS

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
