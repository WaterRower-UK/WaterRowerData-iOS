// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "WaterRowerData-iOS",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "WaterRowerData-BLE",
            targets: ["WaterRowerData-BLE"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "WaterRowerData-BLE",
            dependencies: []
        ),
        .testTarget(
            name: "WaterRowerData-BLETests",
            dependencies: ["WaterRowerData-BLE"]
        )
    ]
)
