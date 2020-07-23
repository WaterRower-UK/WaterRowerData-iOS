import Foundation

/**
 A class that can decode raw bytes into `RowerData` instances.
 
 This class follows the Rower Data characteristic specification
 as described in section 4.8 "Rower Data" of the
 Fitness Machine Service (FTMS) Bluetooth Service specification,
 revision v1.0.
 
 A copy of this specification can be found on
 https://www.bluetooth.com/specifications/gatt/
 */
public class RowerDataCharacteristic {

    /**
     The UUID value that identifies this characteristic.
     */
    public static let uuid = UUID(uuidString: "00002AD1-0000-1000-8000-00805F9B34FB")!

    /**
     Decodes given `data` into a `RowerData` instance.
     
     Due to restrictions in the byte buffer size some of the `RowerData`
     properties will be absent, which is represented as a `nil` value.
     
     - Parameter data: A `Data` instance that contains the encoded data
                       as described in the Rower Data characteristic
                       specification.
     
     - Returns: A `RowerData` instance with the decoded properties.
                Properties will be `nil` if not present in the encoded
                data.
     */
    public static func decode(data: Data) -> RowerData {
        return RowerData(
            strokeRate: strokeRate(from: data),
            strokeCount: strokeCount(from: data),
            averageStrokeRate: averageStrokeRate(from: data),
            totalDistanceMeters: totalDistanceMeters(from: data),
            instantaneousPaceSeconds: instantaneousPaceSeconds(from: data),
            averagePaceSeconds: averagePaceSeconds(from: data),
            instantaneousPowerWatts: instantaneousPower(from: data),
            averagePowerWatts: averagePower(from: data),
            resistanceLevel: resistanceLevel(from: data),
            totalEnergyKiloCalories: totalEnergy(from: data),
            energyPerHourKiloCalories: energyPerHour(from: data),
            energyPerMinuteKiloCalories: energyPerMinute(from: data),
            heartRate: heartRate(from: data),
            metabolicEquivalent: metabolicEquivalent(from: data),
            elapsedTimeSeconds: elapsedTime(from: data),
            remainingTimeSeconds: remainingTime(from: data)
        )
    }

    private static let fields: [Field] = [
        rowerDataFlagsField,
        rowerDataStrokeRateField,
        rowerDataStrokeCountField,
        rowerDataAverageStrokeRateField,
        rowerDataTotalDistanceField,
        rowerDataInstantaneousPaceField,
        rowerDataAveragePaceField,
        rowerDataInstantaneousPowerField,
        rowerDataAveragePowerField,
        rowerDataResistanceLevelField,
        rowerDataTotalEnergyField,
        rowerDataEnergyPerHourField,
        rowerDataEnergyPerMinuteField,
        rowerDataHeartRateField,
        rowerDataMetabolicEquivalentField,
        rowerDataElapsedTimeField,
        rowerDataRemainingTimeField
    ]

    private static func strokeRate(from data: Data) -> Double? {
        guard let intValue = readIntValue(from: data, for: rowerDataStrokeRateField) else {
            return nil
        }

        return Double(intValue) / 2.0
    }

    private static func strokeCount(from data: Data) -> Int? {
        return readIntValue(from: data, for: rowerDataStrokeCountField)
    }

    private static func averageStrokeRate(from data: Data) -> Double? {
        guard let intValue = readIntValue(from: data, for: rowerDataAverageStrokeRateField) else {
            return nil
        }

        return Double(intValue) / 2.0
    }

    private static func totalDistanceMeters(from data: Data) -> Int? {
        return readIntValue(from: data, for: rowerDataTotalDistanceField)
    }

    private static func instantaneousPaceSeconds(from data: Data) -> Int? {
        return readIntValue(from: data, for: rowerDataInstantaneousPaceField)
    }

    private static func averagePaceSeconds(from data: Data) -> Int? {
        return readIntValue(from: data, for: rowerDataAveragePaceField)
    }

    private static func instantaneousPower(from data: Data) -> Int? {
        return readIntValue(from: data, for: rowerDataInstantaneousPowerField)
    }

    private static func averagePower(from data: Data) -> Int? {
        return readIntValue(from: data, for: rowerDataAveragePowerField)
    }

    private static func resistanceLevel(from data: Data) -> Int? {
        return readIntValue(from: data, for: rowerDataResistanceLevelField)
    }

    private static func totalEnergy(from data: Data) -> Int? {
        let result = readIntValue(from: data, for: rowerDataTotalEnergyField)
        if result == 0xFFFF {
            return nil
        }

        return result
    }

    private static func energyPerHour(from data: Data) -> Int? {
        let result = readIntValue(from: data, for: rowerDataEnergyPerHourField)
        if result == 0xFFFF {
            return nil
        }

        return result
    }

    private static func energyPerMinute(from data: Data) -> Int? {
        let result = readIntValue(from: data, for: rowerDataEnergyPerMinuteField)
        if result == 0xFF {
            return nil
        }

        return result
    }

    private static func heartRate(from data: Data) -> Int? {
        return readIntValue(from: data, for: rowerDataHeartRateField)
    }

    private static func metabolicEquivalent(from data: Data) -> Double? {
        guard let intValue = readIntValue(from: data, for: rowerDataMetabolicEquivalentField) else {
            return nil
        }

        return Double(intValue) / 10
    }

    private static func elapsedTime(from data: Data) -> Int? {
        return readIntValue(from: data, for: rowerDataElapsedTimeField)
    }

    private static func remainingTime(from data: Data) -> Int? {
        return readIntValue(from: data, for: rowerDataRemainingTimeField)
    }

    private static func readIntValue(from data: Data, for field: Field) -> Int? {
        if !field.isPresent(in: data) {
            return nil
        }

        var offset = 0
        for i in 0..<fields.count {
            let f = fields[i]
            if f.name == field.name {
                let intValue = data.readIntValue(format: field.format, offset: offset)
                return intValue
            }

            if f.isPresent(in: data) {
                offset += f.format.numberOfBytes()
            }
        }

        return nil
    }
}
