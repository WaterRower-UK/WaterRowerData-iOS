import Foundation
import CoreBluetooth
import WaterRowerData_BLE

class ConnectedRowerDataDevice {

    private let connectedBleDevice: CBConnectedDevice

    init(from device: CBConnectedDevice) {
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
