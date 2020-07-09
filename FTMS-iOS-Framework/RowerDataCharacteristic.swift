import Foundation

class RowerDataCharacteristic {

    static func decode(data: Data) -> RowerData {
        return RowerData(
            averageStrokeRate: averageStrokeRate(from: data),
            totalDistanceMeters: totalDistanceMeters(from: data),
            instantaneousPaceSeconds: instantaneousPaceSeconds(from: data)
        )
    }

    private static let fields: [Field] = [
        rowerDataFlagsField,
        rowerDataAverageStrokeRateField,
        rowerDataTotalDistanceField,
        rowerDataInstantaneousPaceField
    ]

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
