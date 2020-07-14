import SwiftUI

struct DeviceDetailsView: View {

    @ObservedObject var viewModel: DeviceDetailsViewModel

    var body: some View {
        VStack {
            connectionStatusText()

            Spacer()
        }.navigationBarTitle(viewModel.deviceName)
    }

    private func connectionStatusText() -> Text {
        switch viewModel.connectionStatus {
            case .disconnected:
                return Text("Disconnected")
        }
    }
}

struct DeviceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailsView(
            viewModel: DeviceDetailsViewModel(
                deviceName: "My device"
            )
        )
    }
}
