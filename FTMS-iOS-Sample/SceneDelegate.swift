import os
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let scanner = CBBleScanner()
    private var cancellable: Cancellable?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        os_log("scene willConnectToSession", type: .debug)

        let devicesViewModel = DevicesViewModel()
        let devicesView = DevicesView(viewModel: devicesViewModel)

        cancellable = scanner.startScan { result in
            if let name = result.peripheral.name {
                devicesViewModel.append(
                    Device(
                        id: result.peripheral.identifier.uuidString,
                        name: name
                    )
                )
            }
        }

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: devicesView)
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
