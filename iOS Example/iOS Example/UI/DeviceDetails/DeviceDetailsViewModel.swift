import Foundation
import SwiftUI
import WaterRowerData_BLE

class DeviceDetailsViewModel: ObservableObject {

    private let device: Device
    private let connection: CBConnection

    var deviceName: String {
        return device.name
    }

    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var rowerData: RowerData?

    init(_ device: Device) {
        self.device = device
        self.connection = CBConnectionFactory.instance.create(from: device.id)
    }

    private var connectionStatusCancellable: Cancellable?

    func viewDidAppear() {
        connectionStatusCancellable = connection.addConnectionStateListener(connectionStateListener { state in
            self.handle(connectionUpdate: state)
        })
    }

    private var rowerDataCancellable: Cancellable?

    private func handle(connectionUpdate state: CBConnectionState) {
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
            rowerDataCancellable = ConnectedRowerDataDevice(from: device).rowerData { rowerData in
                self.rowerData = rowerData
            }
        } else {
            rowerDataCancellable = nil
            rowerData = nil
        }
    }

    func viewDidDisappear() {
        connectionStatusCancellable = nil
        rowerDataCancellable = nil
        disconnect()
    }

    func connect() {
        connection.connect()
    }

    func disconnect() {
        connection.disconnect()
    }
}
