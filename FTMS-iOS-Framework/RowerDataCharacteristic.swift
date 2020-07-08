import Foundation

struct RowerData {

    let averageStrokeRate: Double?
}

class RowerDataCharacteristic {

    static func decode(data: Data) -> RowerData {
        return RowerData(
            averageStrokeRate: averageStrokeRate(from: data)
        )
    }

    private static func averageStrokeRate(from data: Data) -> Double? {
        let flagsValue = data[0]
        let averageStrokeRatePresent = flagsValue & 0b10 != 0

        if averageStrokeRatePresent {
            return Double(data[2]) * (pow(2.0, -1.0))
        }

        return nil
    }
}
