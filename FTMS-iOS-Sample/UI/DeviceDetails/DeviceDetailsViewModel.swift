import Foundation
import SwiftUI
import FTMS_iOS_Framework

class DeviceDetailsViewModel: ObservableObject {

    private let device: Device
    private let connection: BleConnection

    var deviceName: String {
        return device.name
    }

    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var rowerData: RowerData?

    init(_ device: Device) {
        self.device = device
        self.connection = CBBleConnectionFactory.instance.create(from: device.id)
    }

    private var connectionStatusCancellable: Cancellable?

    func viewDidAppear() {
        connectionStatusCancellable = connection.addConnectionStateListener { state in
            self.handle(connectionUpdate: state)
        }
    }

    private var rowerDataCancellable: Cancellable?

    private func handle(connectionUpdate state: BleConnectionState) {
        switch state {
            case .disconnected:
                self.connectionStatus = .disconnected
            case .connecting:
                self.connectionStatus = .connecting
            case .connected:
                self.connectionStatus = .connected
            case .failed:
                self.connectionStatus = .failed
        }

        if case .connected(device: let device) = state {
            rowerDataCancellable = ConnectedRowerDataBleDevice(from: device).rowerData { rowerData in
                self.rowerData = rowerData
            }
        } else {
            rowerDataCancellable = nil
            rowerData = nil
        }
    }

    func viewDidDisappear() {
        connectionStatusCancellable = nil
        disconnect()
    }

    private var cancellable: Cancellable?

    func connect() {
        connection.connect()
    }

    func disconnect() {
        connection.disconnect()
    }
}
