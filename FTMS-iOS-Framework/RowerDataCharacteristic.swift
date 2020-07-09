import Foundation

class RowerDataCharacteristic {

    static func decode(data: Data) -> RowerData {
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
            metabolicEquivalent: metabolicEquivalent(from: data)
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
        rowerDataMetabolicEquivalentField
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
        return readIntValue(from: data, for: rowerDataTotalEnergyField)
    }

    private static func energyPerHour(from data: Data) -> Int? {
        return readIntValue(from: data, for: rowerDataEnergyPerHourField)
    }

    private static func energyPerMinute(from data: Data) -> Int? {
        return readIntValue(from: data, for: rowerDataEnergyPerMinuteField)
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
