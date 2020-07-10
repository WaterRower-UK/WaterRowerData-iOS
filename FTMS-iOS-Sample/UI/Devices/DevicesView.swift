import SwiftUI

struct DevicesView: View {

    @ObservedObject var viewModel: DevicesViewModel

    var body: some View {
        VStack {
            Text("Available devices")
            DeviceListView(devices: $viewModel.devices)
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView(
            viewModel: DevicesViewModel()
        )
    }
}
