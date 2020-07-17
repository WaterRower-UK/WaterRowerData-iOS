import SwiftUI
import WaterRowerData_BLE

struct DeviceDetailsView: View {

    @ObservedObject var viewModel: DeviceDetailsViewModel

    var body: some View {
        List {
            connectionRow()

            if viewModel.connectionStatus == .connected {
                Group {
                    dataRow(title: "Stroke rate") { rowerData in rowerData?.strokeRate }
                    dataRow(title: "Stroke count") { rowerData in rowerData?.strokeCount }
                    dataRow(title: "Average stroke rate") { rowerData in rowerData?.averageStrokeRate }
                    dataRow(title: "Total distance") { rowerData in rowerData?.totalDistanceMeters }
                    dataRow(title: "Instantaneous pace") { rowerData in rowerData?.instantaneousPaceSeconds }
                    dataRow(title: "Average pace") { rowerData in rowerData?.averagePaceSeconds }
                    dataRow(title: "Instantaneous power") { rowerData in rowerData?.instantaneousPowerWatts }
                    dataRow(title: "Average power") { rowerData in rowerData?.averagePowerWatts }
                    dataRow(title: "Resistance level") { rowerData in rowerData?.resistanceLevel }
                    dataRow(title: "Total energy") { rowerData in rowerData?.totalEnergyKiloCalories }
                }

                Group {
                    dataRow(title: "Energy per hour") { rowerData in rowerData?.energyPerHourKiloCalories }
                    dataRow(title: "Energy per minute") { rowerData in rowerData?.energyPerMinuteKiloCalories }
                    dataRow(title: "Heart rate") { rowerData in rowerData?.heartRate }
                    dataRow(title: "Metabolic equivalent") { rowerData in rowerData?.metabolicEquivalent }
                    dataRow(title: "Elapsed time") { rowerData in rowerData?.elapsedTimeSeconds }
                    dataRow(title: "Remaining time") { rowerData in rowerData?.remainingTimeSeconds }
                }
            }
        }.navigationBarTitle(viewModel.deviceName)
            .onAppear { self.viewModel.viewDidAppear() }
            .onDisappear { self.viewModel.viewDidDisappear() }
    }

    private func connectionRow() -> some View {
        HStack {
            connectionStatusText()
            Spacer()
            connectionButton().buttonStyle(BorderlessButtonStyle())
        }
    }

    private func connectionStatusText() -> Text {
        return Text(viewModel.connectionStatus.rawValue)
    }

    private func connectionButton() -> some View {
        switch viewModel.connectionStatus {
            case .disconnected, .connecting, .failed:
                return AnyView(connectButton(connectionStatus: viewModel.connectionStatus))
            case .connected:
                return AnyView(disconnectButton())
        }
    }

    private func connectButton(connectionStatus: ConnectionStatus) -> some View {
        return Button(action: {
            self.viewModel.connect()
        }) {
            Text("Connect")
        }.disabled(connectionStatus != .disconnected)
    }

    private func disconnectButton() -> some View {
        return Button(action: {
            self.viewModel.disconnect()
        }) {
            Text("Disconnect")
        }.disabled(false)
    }

    private func dataRow(
        title: String,
        value: (RowerData?) -> Any?
    ) -> some View {
        return HStack {
            Text(title)
            Spacer()
            valueText(value: value(viewModel.rowerData))
        }
    }

    private func valueText(value: Any?) -> Text {
        if let value = value {
            return Text(String(describing: value))
        } else {
            return Text("-")
        }
    }
}

struct DeviceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailsView(
            viewModel: DeviceDetailsViewModel(
                Device(id: UUID(), name: "My device")
            )
        )
    }
}
