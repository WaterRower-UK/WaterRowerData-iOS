import os
import CoreBluetooth
import UIKit
import SwiftUI
import WaterRowerData_BLE

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let scanner = CBScanner()
    private var cancellable: Cancellable?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        os_log("scene willConnectToSession", type: .debug)

        let devicesViewModel = DevicesViewModel()
        let devicesView = DevicesView(viewModel: devicesViewModel)

        cancellable = scanner.startScan(
            // withServices: [CBUUID(nsuuid: FitnessMachineService.uuid)]
            withServices: nil
        ) { result in
            if let name = result.peripheral.name {
                devicesViewModel.append(
                    Device(
                        id: result.peripheral.identifier,
                        name: name
                    )
                )
            }
        }

        let rootView = NavigationView { devicesView }

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: rootView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        os_log("sceneDidDisconnect", type: .debug)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        os_log("sceneDidBecomeActive", type: .debug)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        os_log("sceneWillResignActive", type: .debug)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        os_log("sceneWillEnterForeground", type: .debug)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        os_log("sceneDidEnterBackground", type: .debug)
    }
}
