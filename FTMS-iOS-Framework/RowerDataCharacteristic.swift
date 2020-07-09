import Foundation

struct RowerData {

    let averageStrokeRate: Double?
    let totalDistanceMeters: UInt32?
}

class RowerDataCharacteristic {

    static func decode(data: Data) -> RowerData {
        return RowerData(
            averageStrokeRate: averageStrokeRate(from: data),
            totalDistanceMeters: totalDistanceMeters(from: data)
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

    private static func totalDistanceMeters(from data: Data) -> UInt32? {
        let flagsValue = data[0]
        let totalDistancePresent = flagsValue & 0b100 != 0

        if totalDistancePresent {
            return UInt32(data[2]) + (UInt32(data[3]) << 8) + (UInt32(data[4]) << 16)
        }

        return nil
    }
}
