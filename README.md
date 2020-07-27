# WaterRowerData for iOS

A swift package for reading data from a BLE-connected WaterRower device.

## WaterRowerData-BLE

The WaterRowerData-BLE target contains the sources for reading data from
a BLE connected WaterRower device, such as an S5 monitor.
See [WaterRowerData-BLE/Readme](Sources/WaterRowerData-BLE/README.md) for 
usage instructions.

## Setup

To include the package in your project, follow one of the following methods:

### XCode

See [Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app):

 - Select File > Swift Packages > Add Package Dependency
 - Enter `https://github.com/WaterRowerData-UK/WaterRowerData-iOS`
 - Select the version, or leave as is
 - Choose package products and targets
 
### XCodeGen

In your `project.yml` file include the following, replacing `x.x.x` with the
latest release version:

```diff
+ packages:
+   SwiftPM:
+     url: https://github.com/WaterRowerData-UK/WaterRowerData-iOS
+     version: x.x.x
targets:
  App
+    dependencies:
+      - package: SwiftPM
+      - product: WaterRowerData-BLE
```

Run `xcodegen generate`.

## Development

Swift Package Manager is used to test and build this library:

 - `swift build` builds the sources into binaries
 - `swift test` builds and runs the tests

Open `WaterRowerData-iOS.xcodeproj` to start editing the source files.  
Open `iOS Example/iOS Example.xcworkspace` to view and run the sample
application.

## Releasing

See [RELEASING.md](RELEASING.md)
