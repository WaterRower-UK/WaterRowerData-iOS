import Foundation

class DevicesViewModel: ObservableObject {

    @Published var devices = [Device]()

    func append(_ device: Device) {
        if !devices.contains(where: { d in
            d.id == device.id
        }) {
            devices.append(device)
        }
    }
}
