# RELEASING

This library is available via Swift Package Manager and CocoaPods.  
Once you have [configured your setup](#setup), execute the following to
make a release:

 - Update the podspec's `s.version` value in `WaterRowerData-BLE.podspec`
 - Commit the changes
 - Tag the commit as a release: `git tag x.x.x`
 - Push the tags: `git push --tags`
 - Execute `pod lib lint` and ensure there are no errors or warnings
 - Execute `pod trunk push WaterRowerData-BLE.podspec`

## Setup 

You'll need to be authorized to push the library to the CocoaPods trunk.

 - Execute `pod trunk register my@email.com 'My name'`
 - Click on the verification link you've received in your mailbox
 - Request to be added as a maintainer to the project, see https://guides.cocoapods.org/making/getting-setup-with-trunk#adding-other-people-as-contributors
