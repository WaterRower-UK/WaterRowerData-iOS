# WaterRowerData-BLE

This target contains the sources for reading data from a 
BLE connected WaterRower device, such as an S5 monitor.


The BLE enabled WaterRower modules use the FTMS GATT service
specification with the RowerData GATT characteristic.
This target provides classes that decode raw data received
from a GATT characteristic into useable rower data.


## Setup

TODO

## Usage

Once connected to a WaterRower monitor and receiving data 
(see ['Receiving data'](#receiving-data)), you'll receive the data as a [`Data`
byte buffer](https://developer.apple.com/documentation/foundation/data).  
You can pass this `Data` instance into the static 
`RowerData.decode(data: Data)` function to decode the bytes
into a `RowerData` struct:

```swift
import WaterRowerData_BLE

/* ... */

func peripheral(
  _ peripheral: CBPeripheral,
  didUpdateValueFor characteristic: CBCharacteristic,
  error: Error?
) {
  guard let data = characteristic.value else {
    return
  }

  let rowerData = RowerDataCharacteristic.decode(data)
  print(rowerData)
}
```

This `RowerData` struct will contain the rower data that
was encode in the `Data` byte buffer.

> :warning: &ensp; **Note**:  A single `Data` byte buffer instance does not always contain _all_ data values. Due to restrictions in buffer size some of the `RowerData` properties will be absent, which is represented as a `nil` value.


## Receiving data

TODO
