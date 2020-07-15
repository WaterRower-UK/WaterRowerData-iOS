// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "WaterRowerData-iOS",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "WaterRowerData-iOS",
            targets: ["WaterRowerData-iOS"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "WaterRowerData-iOS",
            dependencies: []
        ),
        .testTarget(
            name: "WaterRowerData-iOSTests",
            dependencies: ["WaterRowerData-iOS"]
        ),
    ]
)
