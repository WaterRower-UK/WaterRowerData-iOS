import SwiftUI

struct DevicesView: View {

    @ObservedObject var viewModel: DevicesViewModel

    var body: some View {
        DeviceListView(devices: $viewModel.devices)
            .navigationBarTitle("Available devices")
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView(
            viewModel: DevicesViewModel()
        )
    }
}
