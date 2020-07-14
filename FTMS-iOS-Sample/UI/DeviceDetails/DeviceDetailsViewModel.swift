import Foundation

class DeviceDetailsViewModel: ObservableObject {

    let deviceName: String
    @Published var connectionStatus: ConnectionStatus = .disconnected

    init(deviceName: String) {
        self.deviceName = deviceName
    }
}
